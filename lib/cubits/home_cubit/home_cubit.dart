import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void greet() {
    emit(HomeDisplayGreet());
  }

  void  getCarouselMovies() {
    emit(HomeCarouselMovieLoading());
  }
}