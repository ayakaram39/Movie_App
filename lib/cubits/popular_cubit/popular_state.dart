import '../../models/popular_model.dart';

abstract class PopularState {}

class PopularInitial extends PopularState {}

class PopularLoading extends PopularState {}

class PopularSuccess extends PopularState {
  final PopularResponse popularResponse;

  PopularSuccess(this.popularResponse);
}

class PopularFailure extends PopularState {
  final String message;

  PopularFailure(this.message);
}