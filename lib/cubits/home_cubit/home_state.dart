part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeDisplayGreet extends HomeState {}

final class HomeCarouselMovieLoading extends HomeState {}
final class HomeCarouselMovieSuccess extends HomeState {}
final class HomeCarouselMovieFailure extends HomeState {}