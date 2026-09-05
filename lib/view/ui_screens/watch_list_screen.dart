import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/watch_list_cubit/watch_list_cubit.dart';
import '../../cubits/watch_list_cubit/watch_list_state.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  void initState() {
    super.initState();

    context.read<WatchListCubit>().getWatchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff20252B),
      appBar: AppBar(
        backgroundColor: const Color(0xff20252B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Watch List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<WatchListCubit, WatchListState>(
        builder: (context, state) {
          if (state is WatchListLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff12A8E8),
              ),
            );
          }

          if (state is WatchListFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
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

          if (state is WatchListEmpty) {
            return _buildEmptyWatchList();
          }

          if (state is WatchListSuccess) {
            final movies = state.movies;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
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

                final posterPath = movie['posterPath'];

                return GestureDetector(
                  onLongPress: () {
                    _showRemoveDialog(
                      context,
                      movie['id'],
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: posterPath != null &&
                        posterPath.toString().isNotEmpty
                        ? Image.network(
                      'https://image.tmdb.org/t/p/w500$posterPath',
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return _placeholder();
                      },
                    )
                        : _placeholder(),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showRemoveDialog(
      BuildContext context,
      int movieId,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff30363D),
          title: const Text(
            'Remove Movie',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Do you want to remove this movie from your Watch List?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await context
                    .read<WatchListCubit>()
                    .removeFromWatchList(movieId);
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Color(0xff12A8E8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyWatchList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border,
            color: Colors.grey,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Watch List Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Movies you add to your watch list will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xff30363D),
      child: const Center(
        child: Icon(
          Icons.movie,
          color: Colors.grey,
          size: 35,
        ),
      ),
    );
  }
}