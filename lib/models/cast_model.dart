class CastResponse {
  final int id;
  final List<CastModel> cast;

  CastResponse({
    required this.id,
    required this.cast,
  });

  factory CastResponse.fromJson(Map<String, dynamic> json) {
    return CastResponse(
      id: json['id'] ?? 0,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => CastModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cast': cast.map((e) => e.toJson()).toList(),
    };
  }
}

class CastModel {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;

  CastModel({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      profilePath: json['profile_path'],
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': knownForDepartment,
      'name': name,
      'original_name': originalName,
      'popularity': popularity,
      'profile_path': profilePath,
      'cast_id': castId,
      'character': character,
      'credit_id': creditId,
      'order': order,
    };
  }
}