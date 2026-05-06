import 'package:pilates_app/core/utils/api_media_url.dart';
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
    this.classesThisWeekCount,
    this.totalClassesTaught,
    this.returnRatePercent,
    this.teachingStyles = const [],
    this.ratingBreakdown,
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

  /// When present (e.g. `classesThisWeek`), shown on the trainer list card.
  final int? classesThisWeekCount;

  /// Lifetime / total sessions taught (trainer detail).
  final int? totalClassesTaught;

  /// Return / repeat rate as a whole percent, e.g. `92` for 92%.
  final int? returnRatePercent;

  /// Short labels for teaching style (detail screen).
  final List<String> teachingStyles;

  /// Optional counts per star level from the API: index `0` = 5★ … index `4` = 1★.
  final List<int>? ratingBreakdown;

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
      recentReviews = parseRecentReviewsList(raw);
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
      avatarUrl: resolveApiMediaUrl(
        _nullableString(
          json['imageUrl'] ??
              json['image_url'] ??
              json['avatar_url'] ??
              json['avatarUrl'] ??
              json['image'] ??
              json['photo'],
        ),
      ),
      recentReviews: recentReviews,
      classesThisWeekCount: _optionalInt(
        json['classesThisWeek'] ??
            json['classes_this_week'] ??
            json['weeklyClassesCount'] ??
            json['weekly_classes_count'],
      ),
      totalClassesTaught: _optionalInt(
        json['total_classes_taught'] ??
            json['totalClassesTaught'] ??
            json['lifetime_classes'] ??
            json['classes_taught'],
      ),
      returnRatePercent: _returnRatePercent(
        json['return_rate'] ?? json['returnRate'] ?? json['repeat_rate'],
      ),
      teachingStyles: _stringList(
        json['teaching_styles'] ??
            json['teachingStyles'] ??
            json['style_tags'] ??
            json['teaching_style'],
      ),
      ratingBreakdown: _ratingBreakdown(
        json['ratingBreakdown'] ?? json['rating_breakdown'],
      ),
    );
  }

  /// Five integers: `[5★, 4★, 3★, 2★, 1★]` counts; shorter lists are padded with zeros.
  static List<int>? _ratingBreakdown(dynamic v) {
    if (v is! List) return null;
    final out = <int>[];
    for (final e in v.take(5)) {
      if (e is int) {
        out.add(e < 0 ? 0 : e);
      } else if (e is num) {
        out.add(e.toInt().clamp(0, 1 << 20));
      } else {
        out.add(int.tryParse('$e') ?? 0);
      }
    }
    while (out.length < 5) {
      out.add(0);
    }
    return out;
  }

  static List<String> _stringList(dynamic v) {
    if (v is List) {
      return v.map((e) => '$e'.trim()).where((s) => s.isNotEmpty).toList();
    }
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty) return const [];
      return [t];
    }
    return const [];
  }

  static int? _returnRatePercent(dynamic v) {
    if (v == null) return null;
    if (v is int) return v.clamp(0, 100);
    if (v is num) {
      final d = v.toDouble();
      if (d > 0 && d <= 1) return (d * 100).round().clamp(0, 100);
      return d.round().clamp(0, 100);
    }
    final s = '$v'.trim();
    if (s.isEmpty) return null;
    final n = double.tryParse(s.replaceAll('%', '').replaceAll(',', '.'));
    if (n == null) return null;
    if (n > 0 && n <= 1) return (n * 100).round().clamp(0, 100);
    return n.round().clamp(0, 100);
  }

  static String? _nullableString(dynamic v) {
    if (v == null) return null;
    final s = v is String ? v : '$v';
    final t = s.trim();
    return t.isEmpty ? null : t;
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

/// Shared list/detail formatting for rating line (avoids "—" + "(0)").
extension TrainerResourceRatingUi on TrainerResource {
  bool get hasReviews => reviewsCount > 0;

  /// Non-empty when we can show a numeric average (e.g. "4", "4.5").
  String get displayAverageRating {
    final raw = avgRating;
    if (raw == null) return '';
    var t = raw.trim();
    if (t.isEmpty || t == '—' || t == '-') return '';
    final n = double.tryParse(t.replaceAll(',', '.'));
    if (n == null) return t;
    if (n == n.roundToDouble()) return n.round().toString();
    return n.toStringAsFixed(1);
  }

  /// `avgRating` from the API as 0…5, or `null` if missing / not a number.
  double? get averageRatingValue {
    final raw = avgRating;
    if (raw == null) return null;
    var t = raw.trim();
    if (t.isEmpty || t == '—' || t == '-') return null;
    final n = double.tryParse(t.replaceAll(',', '.'));
    if (n == null) return null;
    return n.clamp(0, 5);
  }
}
