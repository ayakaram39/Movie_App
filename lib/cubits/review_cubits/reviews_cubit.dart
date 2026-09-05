import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_nti_aug/models/review_model.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(ReviewsInitial());

  final Dio dio = Dio();

  Future<void> getReviews(int movieId) async {
    emit(ReviewsLoading());

    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/reviews',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4',
            'accept': 'application/json',
          },
        ),
      );

      final reviewsResponse = ReviewsResponse.fromJson(response.data);

      emit(ReviewsSuccess(reviewsResponse.results));
    } catch (e) {
      print("get reviews error ==>$e");
      emit(ReviewsFailure(e.toString()));
    }
  }
}