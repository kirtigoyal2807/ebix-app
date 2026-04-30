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
    this.capacity,
    this.slotsLeft,
    this.waitlistCount,
    this.gender,
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
  final int? capacity;
  final int? slotsLeft;
  final int? waitlistCount;
  /// Gender restriction for this event: 'Male', 'Female', or null (all genders).
  final String? gender;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
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
          json['branchId']?.toString() ?? json['branch_id']?.toString(),
      branchName: '${json['branchName'] ?? json['branch_name'] ?? ''}',
      branchLocation:
          json['branchLocation']?.toString() ??
          json['branch_location']?.toString(),
      branchAddress:
          json['branchAddress']?.toString() ??
          json['branch_address']?.toString(),
      trainerId:
          json['trainerId']?.toString() ?? json['trainer_id']?.toString(),
      trainerName:
          json['trainerName']?.toString() ?? json['trainer_name']?.toString(),
      capacity: _intOrNull(json['capacity']),
      slotsLeft:
          _intOrNull(json['slotsLeft'] ?? json['slots_left']),
      waitlistCount:
          _intOrNull(json['waitlistCount'] ?? json['waitlist_count']),
      gender: json['gender']?.toString(),
    );
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
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

  final List<UpcomingEvent> upcomingEvents;

  factory GymClassResource.fromJson(Map<String, dynamic> json) {
    final eventsRaw =
        json['upcomingEvents'] ?? json['upcoming_events'];
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
    if (json.containsKey('recentReviews') || json.containsKey('recent_reviews')) {
      final raw = json['recentReviews'] ?? json['recent_reviews'];
      recentReviews = parseRecentReviewsList(raw);
    }

    return GymClassResource(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      description: json['description']?.toString(),
      branchId:
          json['branchId']?.toString() ?? json['branch_id']?.toString(),
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
      isActive:
          json['isActive'] == true || json['is_active'] == true,
      image: json['image']?.toString(),
      avgRating: _doubleOrNull(json['avgRating'] ?? json['avg_rating']),
      reviewsCount:
          _intOrNull(json['reviewsCount'] ?? json['reviews_count']),
      recentReviews: recentReviews,
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
}
