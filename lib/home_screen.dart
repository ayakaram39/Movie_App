import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'movie_details_screen.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'cubits/now_playing_cubits/now_playing_cubit.dart';
import 'cubits/upcoming/upcoming_cubit.dart';
import 'cubits/top_rated/toprated_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().getCarouselMovies();
    context.read<NowPlayingCubit>().getNowPlayingMovies();
    context.read<UpcomingCubit>().getUpcomingMovies();
    context.read<TopRatedCubit>().getTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF242A32),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'What do you want to watch?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF343A40),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeCarouselMovieLoading) {
                      return const SizedBox(
                        height: 210,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0296E5),
                          ),
                        ),
                      );
                    }

                    if (state is HomeCarouselMovieSuccess) {
                      final movies = state.movies;

                      return SizedBox(
                        width: double.infinity,
                        height: 210,
                        child: CarouselSlider(
                          items: movies.map<Widget>((movie) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetailsScreen(
                                          movie: movie,
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF343A40),
                                      child: const Icon(
                                        Icons.movie,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 210,
                            viewportFraction: 0.42,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.25,
                            autoPlay: true,
                            autoPlayInterval:
                            const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                          ),
                        ),
                      );
                    }

                    if (state is HomeCarouselMovieFailure) {
                      return const SizedBox(
                        height: 210,
                        child: Center(
                          child: Text(
                            'Failed to load movies',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }

                    return const SizedBox(
                      height: 210,
                    );
                  },
                ),

                const SizedBox(height: 20),

                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Color(0xFF0296E5),
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  tabs: [
                    Tab(
                      text: 'Now playing',
                    ),
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Top rated',
                    ),
                    Tab(
                      text: 'Popular',
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: TabBarView(
                    children: [
                      _buildNowPlaying(),
                      _buildUpcoming(),
                      _buildTopRated(),
                      _buildPopular(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlaying() {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        if (state is NowPlayingLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0296E5),
            ),
          );
        }

        if (state is NowPlayingFailure) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }

        if (state is NowPlayingSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildUpcoming() {
    return BlocBuilder<UpcomingCubit, UpcomingState>(
      builder: (context, state) {
        if (state is UpcomingLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0296E5),
            ),
          );
        }

        if (state is UpcomingFailure) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }

        if (state is UpcomingSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTopRated() {
    return BlocBuilder<TopRatedCubit, TopRatedState>(
      builder: (context, state) {
        if (state is TopRatedLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0296E5),
            ),
          );
        }

        if (state is TopRatedFailure) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }

        if (state is TopRatedSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildPopular() {
    return const Center(
      child: Text(
        'Popular',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMovieGrid(List movies) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const BouncingScrollPhysics(),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        childAspectRatio: 0.62,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movie: movie,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF343A40),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.grey,
                    size: 35,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}