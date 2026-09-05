import 'package:dio/dio.dart';
import 'guest_serch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestSessionCubit extends Cubit<GuestSessionState> {
  GuestSessionCubit() : super(GuestSessionInitial());

  final Dio dio = Dio();

  final String token = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4';

  Future<void> createGuestSession() async {
    emit(GuestSessionLoading());

    try {
      final response = await dio.post(
        'https://api.themoviedb.org/3/authentication/guest_session/new',
        options: Options(
          headers: {
            'Authorization': token,
            'accept': 'application/json',
          },
        ),
      );

      final guestSessionId =
      response.data['guest_session_id'];

      if (guestSessionId != null) {
        emit(
          GuestSessionSuccess(guestSessionId),
        );
      } else {
        emit(
          GuestSessionFailure(
            'Guest session ID was not returned',
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GuestSessionFailure(
          e.response?.data.toString() ??
              e.message ??
              'Failed to create guest session',
        ),
      );
    } catch (e) {
      emit(
        GuestSessionFailure(
          e.toString(),
        ),
      );
    }
  }
}