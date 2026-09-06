import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:movie_nti_aug/cubits/cast_cubits/cast_cubit.dart';
import 'package:movie_nti_aug/cubits/review_cubits/reviews_cubit.dart';
import 'package:movie_nti_aug/cubits/search_cubits/search_cubit.dart';
import 'package:movie_nti_aug/cubits/popular_cubit/popular_cubit.dart';
import 'package:movie_nti_aug/cubits/popular_cubit/popular_state.dart';
import 'package:movie_nti_aug/models/carousal_movies_model.dart';
import 'package:movie_nti_aug/models/popular_model.dart';
import 'package:movie_nti_aug/view/ui_screens/search_screen.dart';
import 'movie_details_screen.dart';

import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/now_playing_cubits/now_playing_cubit.dart';
import '../../cubits/upcoming/upcoming_cubit.dart';
import '../../cubits/top_rated/toprated_cubit.dart';

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
    context.read<PopularCubit>().getPopularMovies();
  }

  MovieModel _popularToMovieModel(PopularMovieModel movie) {
    return MovieModel(
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      genreIds: movie.genreIds,
      id: movie.id,
      title: movie.title,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      softcore: false,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }

  void _openMovieDetails(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ReviewsCubit()..getReviews(movie.id),
            ),
            BlocProvider(
              create: (context) => CastCubit()..getCast(movie.id),
            ),
          ],
          child: MovieDetailsScreen(
            movie: movie,
          ),
        ),
      ),
    );
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => SearchCubit(),
                          child: const SearchScreen(),
                        ),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
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
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeCarouselMovieLoading) {
                      return const SizedBox(
                        height: 180,
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
                        height: 180,
                        child: CarouselSlider(
                          items: movies.map<Widget>((movie) {
                            return GestureDetector(
                              onTap: () {
                                _openMovieDetails(movie);
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
                            height: 180,
                            viewportFraction: 0.42,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.2,
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
                        height: 180,
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
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0296E5),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
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
                    Tab(text: 'Now playing'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Top rated'),
                    Tab(text: 'Popular'),
                  ],
                ),
                const SizedBox(height: 10),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (state is NowPlayingSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0296E5),
          ),
        );
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (state is UpcomingSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0296E5),
          ),
        );
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (state is TopRatedSuccess) {
          return _buildMovieGrid(state.movies);
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0296E5),
          ),
        );
      },
    );
  }

  Widget _buildPopular() {
    return BlocBuilder<PopularCubit, PopularState>(
      builder: (context, state) {
        if (state is PopularLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0296E5),
            ),
          );
        }

        if (state is PopularFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        if (state is PopularSuccess) {
          final movies = state.popularResponse.results;

          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No popular movies found',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 20,
            ),
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
                  final movieModel = _popularToMovieModel(movie);
                  _openMovieDetails(movieModel);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: movie.posterPath != null &&
                      movie.posterPath!.isNotEmpty
                      ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF343A40),
                        child: const Icon(
                          Icons.movie,
                          color: Colors.grey,
                          size: 35,
                        ),
                      );
                    },
                  )
                      : Container(
                    color: const Color(0xFF343A40),
                    child: const Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 35,
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0296E5),
          ),
        );
      },
    );
  }

  Widget _buildMovieGrid(List movies) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 20,
      ),
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
            _openMovieDetails(movie);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: movie.posterPath != null &&
                movie.posterPath!.isNotEmpty
                ? Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF343A40),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.grey,
                    size: 35,
                  ),
                );
              },
            )
                : Container(
              color: const Color(0xFF343A40),
              child: const Icon(
                Icons.movie,
                color: Colors.grey,
                size: 35,
              ),
            ),
          ),
        );
      },
    );
  }
}