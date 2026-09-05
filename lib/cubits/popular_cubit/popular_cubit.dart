import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/popular_model.dart';
import 'popular_state.dart';

class PopularCubit extends Cubit<PopularState> {
  PopularCubit() : super(PopularInitial());

  final Dio dio = Dio();

  final String token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4';

  Future<void> getPopularMovies() async {
    emit(PopularLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      final popularResponse =
      PopularResponse.fromJson(response.data);

      emit(PopularSuccess(popularResponse));
    } on DioException catch (e) {
      emit(
        PopularFailure(
          e.response?.data.toString() ??
              e.message ??
              'Failed to load popular movies',
        ),
      );
    } catch (e) {
      emit(
        PopularFailure(e.toString()),
      );
    }
  }
}