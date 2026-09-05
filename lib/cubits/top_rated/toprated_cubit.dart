import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/models/carousal_movies_model.dart';

part 'toprated_state.dart';

class TopRatedCubit extends Cubit<TopRatedState> {
  TopRatedCubit() : super(TopRatedInitial());

  void getTopRatedMovies() async {
    emit(TopRatedLoading());

    try {
      var dio = Dio();

      var res = await dio.get(
        'https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1',
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
            'accept': 'application/json',
          },
        ),
      );

      var topRatedMovies =
      CarouselMoviesResponse.fromJson(res.data);

      emit(TopRatedSuccess(topRatedMovies.results));
    } catch (e) {
      emit(TopRatedFailure(e.toString()));
    }
  }
}