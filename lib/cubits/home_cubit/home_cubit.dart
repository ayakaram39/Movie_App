import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:movie_nti_aug/models/carousal_movies_model.dart';
part 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void greet() {
    emit(HomeDisplayGreet());
  }

  void  getCarouselMovies()async {
    emit(HomeCarouselMovieLoading());
    try {
      var dio = Dio();
      var res = await dio.get(
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc",
        options: Options(
          headers: {
            "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      var carouselMovies = CarouselMoviesResponse.fromJson(res.data);
      print(carouselMovies.results.length);
      emit(HomeCarouselMovieSuccess(movies: carouselMovies.results));
    } catch (e) {
      emit(HomeCarouselMovieFailure(message: e.toString()));
    }
  }
  }
