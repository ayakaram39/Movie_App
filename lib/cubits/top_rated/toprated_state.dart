part of 'toprated_cubit.dart';

sealed class TopRatedState {}

class TopRatedInitial extends TopRatedState {}

class TopRatedLoading extends TopRatedState {}

class TopRatedSuccess extends TopRatedState {
  final List movies;

  TopRatedSuccess(this.movies);
}

class TopRatedFailure extends TopRatedState {
  final String message;

  TopRatedFailure(this.message);
}