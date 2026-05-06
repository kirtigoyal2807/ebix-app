/// Parses embedded `recentReviews` / `recent_reviews` arrays from class or trainer payloads.
List<ReviewResource> parseRecentReviewsList(dynamic raw) {
  if (raw is! List) return <ReviewResource>[];
  final out = <ReviewResource>[];
  for (final e in raw) {
    if (e is Map<String, dynamic>) {
      out.add(ReviewResource.fromJson(e));
    } else if (e is Map) {
      out.add(ReviewResource.fromJson(Map<String, dynamic>.from(e)));
    }
  }
  return out;
}

/// Item from `GET /reviews` (Pilates API §14.1).
class ReviewResource {
  const ReviewResource({
    required this.id,
    required this.rating,
    this.body,
    required this.status,
    required this.createdAt,
    required this.reviewer,
  });

  final String id;

  /// 0…5; may be fractional when the API sends decimals.
  final double rating;
  final String? body;
  final String status;
  final DateTime createdAt;
  final ReviewAuthor reviewer;

  factory ReviewResource.fromJson(Map<String, dynamic> json) {
    final reviewerRaw = json['reviewer'];
    ReviewAuthor reviewer;
    if (reviewerRaw is Map) {
      reviewer = ReviewAuthor.fromJson(Map<String, dynamic>.from(reviewerRaw));
    } else {
      reviewer = const ReviewAuthor();
    }
    return ReviewResource(
      id: '${json['id'] ?? ''}',
      rating: _ratingValue(json['rating']),
      body: json['body'] is String
          ? (json['body'] as String).trim()
          : json['body']?.toString().trim().isNotEmpty == true
          ? '${json['body']}'.trim()
          : null,
      status: '${json['status'] ?? ''}',
      createdAt:
          _parseDate(json['createdAt'] ?? json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      reviewer: reviewer,
    );
  }

  static double _ratingValue(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble().clamp(0, 5);
    final n = double.tryParse('$v'.replaceAll(',', '.'));
    if (n == null) return 0;
    return n.clamp(0, 5);
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v.toUtc();
    final s = '$v'.trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s)?.toUtc() ??
        DateTime.tryParse(s.replaceFirst(' ', 'T'))?.toUtc();
  }
}

class ReviewAuthor {
  const ReviewAuthor({this.id, this.name, this.avatarUrl});

  final String? id;
  final String? name;
  final String? avatarUrl;

  factory ReviewAuthor.fromJson(Map<String, dynamic> json) {
    return ReviewAuthor(
      id: json['id'] != null ? '${json['id']}' : null,
      name: () {
        final n = json['name'] ?? json['displayName'];
        if (n == null) return null;
        final t = '$n'.trim();
        return t.isEmpty ? null : t;
      }(),
      avatarUrl:
          json['avatar'] as String? ??
          json['avatarUrl'] as String? ??
          json['avatar_url'] as String?,
    );
  }
}
