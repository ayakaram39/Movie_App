import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/watch_list_cubit/watch_list_cubit.dart';
import '../../cubits/watch_list_cubit/watch_list_state.dart';
import '../../models/search_model.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.movie,
  });

  final SearchModel movie;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchListCubit()..getWatchList(),
      child: _SearchCardContent(movie: movie),
    );
  }
}

class _SearchCardContent extends StatelessWidget {
  const _SearchCardContent({
    required this.movie,
  });

  final SearchModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 100,
              height: 150,
              child: movie.posterPath != null &&
                  movie.posterPath!.isNotEmpty
                  ? Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    BlocBuilder<WatchListCubit, WatchListState>(
                      builder: (context, state) {
                        bool isSaved = false;

                        if (state is WatchListSuccess) {
                          isSaved = state.movies.any(
                                (savedMovie) =>
                            savedMovie['id'] == movie.id,
                          );
                        }

                        return IconButton(
                          onPressed: () async {
                            final watchListCubit =
                            context.read<WatchListCubit>();

                            if (isSaved) {
                              await watchListCubit.removeFromWatchList(
                                movie.id,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Movie removed from Watch List',
                                  ),
                                ),
                              );
                            } else {
                              await watchListCubit.addToWatchList(
                                id: movie.id,
                                title: movie.title,
                                posterPath: movie.posterPath,
                                voteAverage: movie.voteAverage,
                                genres: movie.genres,
                                releaseDate: movie.releaseDate,
                                runtime: movie.runtime,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Movie added to Watch List',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isSaved
                                ? const Color(0xff12A8E8)
                                : Colors.white,
                            size: 25,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xffFFB400),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xff12A8E8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.movie_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        movie.genres.isNotEmpty
                            ? movie.genres.join(', ')
                            : 'Movie',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      movie.releaseDate.isNotEmpty
                          ? movie.releaseDate.substring(0, 4)
                          : 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      movie.runtime != null
                          ? '${movie.runtime} minutes'
                          : 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
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
          size: 40,
        ),
      ),
    );
  }
}