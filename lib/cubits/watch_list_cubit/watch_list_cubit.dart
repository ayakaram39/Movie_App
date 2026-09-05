import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'watch_list_state.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit() : super(WatchListInitial());

  static const String _watchListKey = 'watch_list';

  Future<void> getWatchList() async {
    emit(WatchListLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedMovies = prefs.getStringList(_watchListKey) ?? [];

      final movies = savedMovies.map((movie) {
        return Map<String, dynamic>.from(
          jsonDecode(movie) as Map,
        );
      }).toList();

      if (movies.isEmpty) {
        emit(WatchListEmpty());
      } else {
        emit(WatchListSuccess(movies));
      }
    } catch (e) {
      emit(
        WatchListFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addToWatchList({
    required int id,
    required String title,
    String? posterPath,
    required double voteAverage,
    required List<String> genres,
    required String releaseDate,
    int? runtime,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedMovies = prefs.getStringList(_watchListKey) ?? [];

      final movies = savedMovies.map((movie) {
        return Map<String, dynamic>.from(
          jsonDecode(movie) as Map,
        );
      }).toList();

      final alreadyExists = movies.any(
            (movie) => movie['id'] == id,
      );

      if (!alreadyExists) {
        final movie = {
          'id': id,
          'title': title,
          'posterPath': posterPath,
          'voteAverage': voteAverage,
          'genres': genres,
          'releaseDate': releaseDate,
          'runtime': runtime,
        };

        movies.add(movie);

        final encodedMovies = movies.map(
              (movie) => jsonEncode(movie),
        ).toList();

        await prefs.setStringList(
          _watchListKey,
          encodedMovies,
        );
      }

      await getWatchList();
    } catch (e) {
      emit(
        WatchListFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> removeFromWatchList(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedMovies = prefs.getStringList(_watchListKey) ?? [];
      print('Saved movies: $savedMovies');

      final movies = savedMovies.map((movie) {
        return Map<String, dynamic>.from(
          jsonDecode(movie) as Map,
        );
      }).toList();

      movies.removeWhere(
            (movie) => movie['id'] == id,
      );

      final encodedMovies = movies.map(
            (movie) => jsonEncode(movie),
      ).toList();

      await prefs.setStringList(
        _watchListKey,
        encodedMovies,
      );

      await getWatchList();
    } catch (e) {
      emit(
        WatchListFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<bool> isInWatchList(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final savedMovies = prefs.getStringList(_watchListKey) ?? [];

    return savedMovies.any((movie) {
      final data = jsonDecode(movie) as Map;

      return data['id'] == id;
    });
  }
}