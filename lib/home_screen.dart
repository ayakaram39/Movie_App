import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'cubits/Now_playing_cubits/now_playing_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isshow = true;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCarouselMovies();
    context.read<NowPlayingCubit>().getNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF242A32),
        elevation: 0,
        title: const Text(
          'What do you want to watch?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFF343A40),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeCarouselMovieLoading) {
                  return const CircularProgressIndicator();
                }

                if (state is HomeCarouselMovieSuccess) {
                  var movies = state.movies;

                  return SizedBox(
                    width: double.infinity,
                    height: 210,
                    child: CarouselSlider(
                      items: movies.map<Widget>((movie) {
                        return Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 210,
                        viewportFraction: 0.4,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),

            const SizedBox(height: 25),

            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.orange,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Now playing'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Top rated'),
                        Tab(text: 'Popular'),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Expanded(
                      child: TabBarView(
                        children: [
                          BlocBuilder<NowPlayingCubit, NowPlayingState>(
                            builder: (context, state) {
                              if (state is NowPlayingLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (state is NowPlayingFailure) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }

                              if (state is NowPlayingSuccess) {
                                var movies = state.movies;

                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.62,
                                  ),
                                  itemCount: movies.length,
                                  itemBuilder: (context, index) {
                                    var movie = movies[index];

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                );
                              }

                              return const SizedBox();
                            },
                          ),

                          const Center(
                            child: Text(
                              'Upcoming',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          const Center(
                            child: Text(
                              'Top rated',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          const Center(
                            child: Text(
                              'Popular',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}