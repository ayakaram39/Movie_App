class ReviewsModel {
  final String author;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String id;
  final String url;
  final AuthorDetails authorDetails;

  ReviewsModel({
    required this.author,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.url,
    required this.authorDetails,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      authorDetails: AuthorDetails.fromJson(
        json['author_details'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id': id,
      'url': url,
      'author_details': authorDetails.toJson(),
    };
  }
}

class AuthorDetails {
  final String? name;
  final String? username;
  final String? avatarPath;
  final double? rating;

  AuthorDetails({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) {
    return AuthorDetails(
      name: json['name'],
      username: json['username'],
      avatarPath: json['avatar_path'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'avatar_path': avatarPath,
      'rating': rating,
    };
  }
}

class ReviewsResponse {
  final int id;
  final int page;
  final List<ReviewsModel> results;
  final int totalPages;
  final int totalResults;

  ReviewsResponse({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      id: json['id'] ?? 0,
      page: json['page'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ReviewsModel.fromJson(e))
          .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}