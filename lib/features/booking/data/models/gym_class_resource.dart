import 'package:pilates_app/core/utils/api_media_url.dart';

import 'review_resource.dart';

/// §13.2 List All Class Types — `GET /classes`
/// Each GymClassResource contains a list of upcoming scheduled events.
class UpcomingEvent {
  const UpcomingEvent({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.branchId,
    required this.branchName,
    this.branchLocation,
    this.branchAddress,
    this.trainerId,
    this.trainerName,
    this.trainerImageUrl,
    this.capacity,
    this.slotsLeft,
    this.waitlistCount,
    this.gender,
    this.category,
  });

  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? branchId;
  final String branchName;
  final String? branchLocation;
  final String? branchAddress;
  final String? trainerId;
  final String? trainerName;
  final String? trainerImageUrl;
  final int? capacity;
  final int? slotsLeft;
  final int? waitlistCount;

  /// Gender restriction for this event: 'Male', 'Female', or null (all genders).
  final String? gender;
  final String? category;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    final branchMap = _mapOrNull(json['branch']);
    final trainerMap = _mapOrNull(json['trainer']);
    final trainerUserMap = _mapOrNull(trainerMap?['user']);
    final genderRaw =
        json['gender'] ?? json['targetGender'] ?? json['target_gender'];
    final categoryRaw =
        json['category'] ??
        json['classCategory'] ??
        json['class_category'] ??
        json['classType'] ??
        json['class_type'] ??
        json['type'];

    return UpcomingEvent(
      id: '${json['id'] ?? ''}',
      startAt:
          DateTime.tryParse('${json['startAt'] ?? json['start_at'] ?? ''}') ??
          DateTime.now(),
      endAt:
          DateTime.tryParse('${json['endAt'] ?? json['end_at'] ?? ''}') ??
          DateTime.now(),
      status: '${json['status'] ?? 'scheduled'}',
      branchId:
          json['branchId']?.toString() ??
          json['branch_id']?.toString() ??
          branchMap?['id']?.toString() ??
          branchMap?['branchId']?.toString() ??
          branchMap?['branch_id']?.toString(),
      branchName:
          '${json['branchName'] ?? json['branch_name'] ?? branchMap?['name'] ?? branchMap?['branchName'] ?? branchMap?['branch_name'] ?? ''}',
      branchLocation:
          json['branchLocation']?.toString() ??
          json['branch_location']?.toString() ??
          branchMap?['location']?.toString() ??
          branchMap?['branchLocation']?.toString() ??
          branchMap?['branch_location']?.toString(),
      branchAddress:
          json['branchAddress']?.toString() ??
          json['branch_address']?.toString() ??
          branchMap?['address']?.toString() ??
          branchMap?['branchAddress']?.toString() ??
          branchMap?['branch_address']?.toString(),
      trainerId:
          json['trainerId']?.toString() ??
          json['trainer_id']?.toString() ??
          trainerMap?['id']?.toString() ??
          trainerMap?['trainerId']?.toString() ??
          trainerMap?['trainer_id']?.toString() ??
          trainerUserMap?['id']?.toString(),
      trainerName:
          json['trainerName']?.toString() ??
          json['trainer_name']?.toString() ??
          trainerMap?['displayName']?.toString() ??
          trainerMap?['display_name']?.toString() ??
          trainerMap?['name']?.toString() ??
          trainerUserMap?['displayName']?.toString() ??
          trainerUserMap?['display_name']?.toString() ??
          trainerUserMap?['name']?.toString(),
      trainerImageUrl: resolveApiMediaUrl(
        json['trainerImageUrl']?.toString() ??
            json['trainer_image_url']?.toString() ??
            json['trainerAvatarUrl']?.toString() ??
            json['trainer_avatar_url']?.toString() ??
            json['trainerPhotoUrl']?.toString() ??
            json['trainer_photo_url']?.toString() ??
            json['trainerImage']?.toString() ??
            json['trainer_image']?.toString() ??
            trainerMap?['imageUrl']?.toString() ??
            trainerMap?['image_url']?.toString() ??
            trainerMap?['avatarUrl']?.toString() ??
            trainerMap?['avatar_url']?.toString() ??
            trainerMap?['profileImage']?.toString() ??
            trainerMap?['profile_image']?.toString() ??
            trainerMap?['image']?.toString() ??
            trainerMap?['photo']?.toString() ??
            trainerUserMap?['imageUrl']?.toString() ??
            trainerUserMap?['image_url']?.toString() ??
            trainerUserMap?['avatarUrl']?.toString() ??
            trainerUserMap?['avatar_url']?.toString() ??
            trainerUserMap?['profileImage']?.toString() ??
            trainerUserMap?['profile_image']?.toString() ??
            trainerUserMap?['image']?.toString() ??
            trainerUserMap?['photo']?.toString(),
      ),
      capacity: _intOrNull(json['capacity']),
      slotsLeft: _intOrNull(json['slotsLeft'] ?? json['slots_left']),
      waitlistCount: _intOrNull(
        json['waitlistCount'] ?? json['waitlist_count'],
      ),
      gender: _stringOrNull(genderRaw),
      category: _stringOrNull(categoryRaw),
    );
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  static Map<String, dynamic>? _mapOrNull(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final map = _mapOrNull(value);
      final nestedValue =
          map?['value'] ?? map?['name'] ?? map?['label'] ?? map?['code'];
      return _stringOrNull(nestedValue);
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  bool get isFull => slotsLeft != null && slotsLeft! <= 0;
}

class GymClassResource {
  const GymClassResource({
    required this.id,
    required this.name,
    this.description,
    this.branchId,
    this.defaultDurationMinutes,
    this.defaultCapacity,
    this.basePrice,
    required this.allowSinglePurchase,
    required this.allowPackageBooking,
    required this.isActive,
    this.image,
    this.avgRating,
    this.reviewsCount,
    this.recentReviews,
    this.category,
    this.gender,
    required this.upcomingEvents,
  });

  final String id;
  final String name;
  final String? description;
  final String? branchId;
  final int? defaultDurationMinutes;
  final int? defaultCapacity;
  final double? basePrice;
  final bool allowSinglePurchase;
  final bool allowPackageBooking;
  final bool isActive;
  final String? image;
  final double? avgRating;
  final int? reviewsCount;

  /// Present when the API includes `recentReviews` / `recent_reviews` (may be `[]`).
  /// If omitted, this is null and the client may load reviews via `GET /reviews`.
  final List<ReviewResource>? recentReviews;
  final String? category;
  final String? gender;

  final List<UpcomingEvent> upcomingEvents;

  factory GymClassResource.fromJson(Map<String, dynamic> json) {
    final eventsRaw = json['upcomingEvents'] ?? json['upcoming_events'];
    final parsedEvents = <UpcomingEvent>[];
    if (eventsRaw is List) {
      for (final e in eventsRaw) {
        if (e is Map<String, dynamic>) {
          parsedEvents.add(UpcomingEvent.fromJson(e));
        } else if (e is Map) {
          parsedEvents.add(
            UpcomingEvent.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    List<ReviewResource>? recentReviews;
    if (json.containsKey('recentReviews') ||
        json.containsKey('recent_reviews')) {
      final raw = json['recentReviews'] ?? json['recent_reviews'];
      recentReviews = parseRecentReviewsList(raw);
    }

    final classGenderRaw =
        json['gender'] ?? json['targetGender'] ?? json['target_gender'];
    final classCategoryRaw =
        json['category'] ??
        json['classCategory'] ??
        json['class_category'] ??
        json['classType'] ??
        json['class_type'] ??
        json['type'];

    return GymClassResource(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      description: json['description']?.toString(),
      branchId: json['branchId']?.toString() ?? json['branch_id']?.toString(),
      defaultDurationMinutes: _intOrNull(
        json['defaultDurationMinutes'] ?? json['default_duration_minutes'],
      ),
      defaultCapacity: _intOrNull(
        json['defaultCapacity'] ?? json['default_capacity'],
      ),
      basePrice: _doubleOrNull(json['basePrice'] ?? json['base_price']),
      allowSinglePurchase:
          json['allowSinglePurchase'] == true ||
          json['allow_single_purchase'] == true,
      allowPackageBooking:
          json['allowPackageBooking'] == true ||
          json['allow_package_booking'] == true,
      isActive: json['isActive'] == true || json['is_active'] == true,
      image: resolveApiMediaUrl(json['image']?.toString()),
      avgRating: _doubleOrNull(json['avgRating'] ?? json['avg_rating']),
      reviewsCount: _intOrNull(json['reviewsCount'] ?? json['reviews_count']),
      recentReviews: recentReviews,
      category: _stringOrNull(classCategoryRaw),
      gender: _stringOrNull(classGenderRaw),
      upcomingEvents: parsedEvents,
    );
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  static double? _doubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  static String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final map = value is Map<String, dynamic>
          ? value
          : Map<String, dynamic>.from(value);
      final nestedValue =
          map['value'] ?? map['name'] ?? map['label'] ?? map['code'];
      return _stringOrNull(nestedValue);
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
