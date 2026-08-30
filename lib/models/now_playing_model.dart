import 'package:movie_nti_aug/models/carousal_movies_model.dart';

class NowPlayingResponse {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  NowPlayingResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) {
    return NowPlayingResponse(
      page: json['page'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e))
          .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}