import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_nti_aug/models/cast_model.dart';

part 'cast_state.dart';

class CastCubit extends Cubit<CastState> {
  CastCubit() : super(CastInitial());

  Future<void> getCast(int movieId) async {
    emit(CastLoading());

    try {
      final dio = Dio();

      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/credits',
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
            'accept': 'application/json',
          },
        ),
      );

      final castResponse = CastResponse.fromJson(response.data);

      emit(
        CastSuccess(
          cast: castResponse.cast,
        ),
      );
    } catch (e) {
      emit(
        CastFailure(
          message: e.toString(),
        ),
      );
    }
  }
}