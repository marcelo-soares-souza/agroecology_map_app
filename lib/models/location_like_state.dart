class LocationLikeState {
  final int likesCount;
  final bool liked;

  const LocationLikeState({
    required this.likesCount,
    required this.liked,
  });

  factory LocationLikeState.fromJson(Map<String, dynamic> json) {
    return LocationLikeState(
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      liked: json['liked'] == true,
    );
  }
}

class LocationLikeException implements Exception {
  final String message;
  final int? statusCode;

  const LocationLikeException(this.message, {this.statusCode});

  @override
  String toString() => 'LocationLikeException(statusCode: $statusCode, message: $message)';
}
