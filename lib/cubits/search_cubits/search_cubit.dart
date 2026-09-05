import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/models/search_model.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final Dio dio = Dio();

  final String token = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4';

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'query': query,
          'include_adult': false,
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      final searchResponse =
      SearchResponse.fromJson(response.data);

      await Future.wait(
        searchResponse.results.map(
              (movie) async {
            try {
              final detailsResponse = await dio.get(
                'https://api.themoviedb.org/3/movie/${movie.id}',
                queryParameters: {
                  'language': 'en-US',
                },
                options: Options(
                  headers: {
                    'Authorization': token,
                  },
                ),
              );

              movie.runtime = detailsResponse.data['runtime'];

              final genres =
              detailsResponse.data['genres'] as List<dynamic>?;

              movie.genres = genres
                  ?.map(
                    (genre) => genre['name'].toString(),
              )
                  .toList() ??
                  [];
            } catch (e) {
              print('Details error for ${movie.title}: $e');

              movie.runtime = null;
              movie.genres = [];
            }
          },
        ),
      );

      emit(SearchSuccess(searchResponse));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}