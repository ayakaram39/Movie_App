class WatchListResponse {
  final int page;
  final List<WatchListModel> results;
  final int totalPages;
  final int totalResults;

  WatchListResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory WatchListResponse.fromJson(Map<String, dynamic> json) {
    return WatchListResponse(
      page: json['page'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map(
            (movie) => WatchListModel.fromJson(movie),
      )
          .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class WatchListModel {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  WatchListModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory WatchListModel.fromJson(Map<String, dynamic> json) {
    return WatchListModel(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }
}