part of 'upcoming_cubit.dart';

@immutable
sealed class UpcomingState {}

final class UpcomingInitial extends UpcomingState {}

final class UpcomingLoading extends UpcomingState {}

final class UpcomingSuccess extends UpcomingState {
  final List movies;

  UpcomingSuccess({
    required this.movies,
  });
}

final class UpcomingFailure extends UpcomingState {
  final String message;

  UpcomingFailure({
    required this.message,
  });
}