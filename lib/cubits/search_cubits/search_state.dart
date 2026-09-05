import 'package:movie_nti_aug/models/search_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final SearchResponse searchResponse;

  SearchSuccess(this.searchResponse);
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}