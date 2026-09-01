import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/home_cubit/home_cubit.dart';
import 'cubits/Now_playing_cubits/now_playing_cubit.dart';
import 'cubits/upcoming/upcoming_cubit.dart';
import 'cubits/top_rated/toprated_cubit.dart';
import 'models/carousal_movies_model.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    'Now playing',
    'Upcoming',
    'Top rated',
    'Popular',
  ];

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
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
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

              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xff3A3F47),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Color(0xff8D8D92),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff8D8D92),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeCarouselMovieLoading) {
                    return const SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is HomeCarouselMovieSuccess) {
                    final movies = state.movies;

                    return SizedBox(
                      height: 220,
                      child: CarouselSlider.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index, realIndex) {
                          final movie = movies[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailsScreen(movie: movie),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xff3A3F47),
                                    child: const Icon(
                                      Icons.movie,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 210,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.4,
                          autoPlayInterval:
                          const Duration(seconds: 3),
                        ),
                      ),
                    );
                  }

                  if (state is HomeCarouselMovieFailure) {
                    return SizedBox(
                      height: 220,
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 220,
                  );
                },
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedTab == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 25),
                        child: Column(
                          children: [
                            Text(
                              tabs[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xff8D8D92),
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (isSelected)
                              Container(
                                width: 40,
                                height: 2,
                                color: const Color(0xff0296E5),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: _buildSelectedMovies(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMovies() {
    if (selectedTab == 0) {
      return BlocBuilder<NowPlayingCubit, NowPlayingState>(
        builder: (context, state) {
          if (state is NowPlayingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NowPlayingSuccess) {
            return _buildMovieGrid(state.movies);
          }

          if (state is NowPlayingFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      );
    }

    if (selectedTab == 1) {
      return BlocBuilder<UpcomingCubit, UpcomingState>(
        builder: (context, state) {
          if (state is UpcomingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UpcomingSuccess) {
            return _buildMovieGrid(state.movies);
          }

          if (state is UpcomingFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      );
    }

    if (selectedTab == 2) {
      return BlocBuilder<TopRatedCubit, TopRatedState>(
        builder: (context, state) {
          if (state is TopRatedLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TopRatedSuccess) {
            return _buildMovieGrid(state.movies);
          }

          if (state is TopRatedFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      );
    }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeCarouselMovieSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildMovieGrid(List<MovieModel> movies) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 15,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MovieDetailsScreen(movie: movie),
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
                  color: const Color(0xff3A3F47),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white,
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