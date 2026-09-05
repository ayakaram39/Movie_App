import 'package:flutter/material.dart';
import '../../models/watch_list_model.dart';

class WatchListCard extends StatelessWidget {
  final WatchListModel movie;

  const WatchListCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: movie.posterPath != null
                ? Image.network(
              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
              width: 75,
              height: 100,
              fit: BoxFit.cover,
            )
                : Container(
              width: 75,
              height: 100,
              color: const Color(0xff30363D),
              child: const Icon(
                Icons.movie,
                color: Colors.white54,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xffFFB800),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xffFFB800),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.movie_outlined,
                      color: Color(0xff858A90),
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Action',
                      style: TextStyle(
                        color: Color(0xff858A90),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xff858A90),
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      movie.releaseDate.isNotEmpty
                          ? movie.releaseDate.substring(0, 4)
                          : 'N/A',
                      style: const TextStyle(
                        color: Color(0xff858A90),
                        fontSize: 12,
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
}