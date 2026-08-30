import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:movie_nti_aug/models/carousal_movies_model.dart';
import 'package:movie_nti_aug/models/now_playing_model.dart';

part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingInitial());

  void getNowPlayingMovies() async {
    emit(NowPlayingLoading());

    try {
      var dio = Dio();

      var res = await dio.get(
        "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1",
        options: Options(
          headers: {
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      var nowPlayingMovies =
      CarouselMoviesResponse.fromJson(res.data);

      print(nowPlayingMovies.results.length);

      emit(
        NowPlayingSuccess(
          movies: nowPlayingMovies.results,
        ),
      );
    } catch (e) {
      emit(
        NowPlayingFailure(
          message: e.toString(),
        ),
      );
    }
  }
}