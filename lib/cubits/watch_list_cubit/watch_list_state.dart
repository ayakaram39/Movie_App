abstract class WatchListState {}

class WatchListInitial extends WatchListState {}

class WatchListLoading extends WatchListState {}

class WatchListSuccess extends WatchListState {
  final List<Map<String, dynamic>> movies;

  WatchListSuccess(this.movies);
}

class WatchListEmpty extends WatchListState {}

class WatchListFailure extends WatchListState {
  final String message;

  WatchListFailure(this.message);
}