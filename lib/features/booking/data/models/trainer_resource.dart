import 'package:pilates_app/core/utils/html_plain_text.dart';

import 'review_resource.dart';
import 'trainer_branch_summary.dart';
import 'trainer_certification.dart';

/// Pilates API §12.1 / §12.2 — trainer list and detail payload.
class TrainerResource {
  const TrainerResource({
    required this.id,
    required this.displayName,
    this.bio,
    required this.specialties,
    this.yearsExperience,
    this.avgRating,
    this.reviewsCount = 0,
    this.isActive = true,
    required this.certifications,
    required this.branches,
    this.avatarUrl,
    this.recentReviews,
  });

  final String id;
  final String displayName;
  final String? bio;
  final List<String> specialties;
  final int? yearsExperience;
  final String? avgRating;
  final int reviewsCount;
  final bool isActive;
  final List<TrainerCertification> certifications;
  final List<TrainerBranchSummary> branches;
  final String? avatarUrl;

  /// Present when the API includes `recentReviews` / `recent_reviews` (may be `[]`).
  /// If omitted from JSON, this is null and the client may load reviews via `GET /reviews`.
  final List<ReviewResource>? recentReviews;

  factory TrainerResource.fromJson(Map<String, dynamic> json) {
    final specialtiesRaw = json['specialties'];
    final specialties = <String>[];
    if (specialtiesRaw is List) {
      for (final e in specialtiesRaw) {
        specialties.add('$e');
      }
    }

    final certsRaw = json['certifications'];
    final certifications = <TrainerCertification>[];
    if (certsRaw is List) {
      for (final e in certsRaw) {
        if (e is Map<String, dynamic>) {
          certifications.add(TrainerCertification.fromJson(e));
        } else if (e is Map) {
          certifications.add(
            TrainerCertification.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    final branchesRaw = json['branches'];
    final branches = <TrainerBranchSummary>[];
    if (branchesRaw is List) {
      for (final e in branchesRaw) {
        if (e is Map<String, dynamic>) {
          branches.add(TrainerBranchSummary.fromJson(e));
        } else if (e is Map) {
          branches.add(TrainerBranchSummary.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }

    List<ReviewResource>? recentReviews;
    if (json.containsKey('recentReviews') || json.containsKey('recent_reviews')) {
      final raw = json['recentReviews'] ?? json['recent_reviews'];
      recentReviews = _parseRecentReviews(raw);
    }

    return TrainerResource(
      id: '${json['id'] ?? ''}',
      displayName: '${json['display_name'] ?? json['displayName'] ?? ''}',
      bio: _bioFromJson(json['bio']),
      specialties: specialties,
      yearsExperience: _optionalInt(json['years_experience'] ?? json['yearsExperience']),
      avgRating: json['avg_rating']?.toString() ?? json['avgRating']?.toString(),
      reviewsCount: _int(json['reviews_count'] ?? json['reviewsCount'], 0),
      isActive: json['is_active'] != false && json['isActive'] != false,
      certifications: certifications,
      branches: branches,
      avatarUrl: json['avatar_url'] as String? ??
          json['avatarUrl'] as String? ??
          json['image'] as String? ??
          json['photo'] as String?,
      recentReviews: recentReviews,
    );
  }

  static List<ReviewResource> _parseRecentReviews(dynamic raw) {
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

  static int? _optionalInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  static int _int(dynamic v, int fallback) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? fallback;
  }

  static String? _bioFromJson(dynamic v) {
    if (v == null) return null;
    final s = htmlToPlainText(v is String ? v : '$v');
    return s.isEmpty ? null : s;
  }
}
