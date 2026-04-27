import 'review_resource.dart';

/// §13.5 Class Event Detail — `GET /classes/events/{eventId}`
/// Returns one specific calendar slot with its parent class template embedded.
class ClassEventDetailClass {
  const ClassEventDetailClass({
    required this.id,
    required this.name,
    this.description,
    this.defaultDurationMinutes,
    this.defaultCapacity,
    this.basePrice,
    required this.allowSinglePurchase,
    required this.allowPackageBooking,
    required this.isActive,
    this.image,
    this.recentReviews,
  });

  final String id;
  final String name;
  final String? description;
  final int? defaultDurationMinutes;
  final int? defaultCapacity;
  final double? basePrice;
  final bool allowSinglePurchase;
  final bool allowPackageBooking;
  final bool isActive;
  final String? image;

  /// Embedded on `class` when the API includes `recentReviews` (may be `[]`).
  final List<ReviewResource>? recentReviews;

  factory ClassEventDetailClass.fromJson(Map<String, dynamic> json) {
    List<ReviewResource>? recentReviews;
    if (json.containsKey('recentReviews') || json.containsKey('recent_reviews')) {
      final raw = json['recentReviews'] ?? json['recent_reviews'];
      recentReviews = parseRecentReviewsList(raw);
    }

    return ClassEventDetailClass(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      description: json['description']?.toString(),
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
      recentReviews: recentReviews,
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

class ClassEventDetail {
  const ClassEventDetail({
    required this.eventId,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.capacity,
    this.slotsLeft,
    this.waitlistCount,
    this.trainerId,
    this.trainerName,
    this.branchId,
    this.branchName,
    this.branchLocation,
    this.branchAddress,
    this.gymClass,
  });

  final String eventId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final int? capacity;
  final int? slotsLeft;
  final int? waitlistCount;
  final String? trainerId;
  final String? trainerName;
  final String? branchId;
  final String? branchName;
  final String? branchLocation;
  final String? branchAddress;
  final ClassEventDetailClass? gymClass;

  bool get isFull => slotsLeft != null && slotsLeft! <= 0;

  factory ClassEventDetail.fromJson(Map<String, dynamic> json) {
    final classJson = json['class'];
    ClassEventDetailClass? gymClass;
    if (classJson is Map<String, dynamic>) {
      gymClass = ClassEventDetailClass.fromJson(classJson);
    } else if (classJson is Map) {
      gymClass = ClassEventDetailClass.fromJson(
        Map<String, dynamic>.from(classJson),
      );
    }

    return ClassEventDetail(
      eventId:
          '${json['eventId'] ?? json['event_id'] ?? json['id'] ?? ''}',
      startAt:
          DateTime.tryParse('${json['startAt'] ?? json['start_at'] ?? ''}') ??
          DateTime.now(),
      endAt:
          DateTime.tryParse('${json['endAt'] ?? json['end_at'] ?? ''}') ??
          DateTime.now(),
      status: '${json['status'] ?? 'scheduled'}',
      capacity: _intOrNull(json['capacity']),
      slotsLeft:
          _intOrNull(json['slotsLeft'] ?? json['slots_left']),
      waitlistCount:
          _intOrNull(json['waitlistCount'] ?? json['waitlist_count']),
      trainerId:
          json['trainerId']?.toString() ?? json['trainer_id']?.toString(),
      trainerName:
          json['trainerName']?.toString() ??
          json['trainer_name']?.toString(),
      branchId:
          json['branchId']?.toString() ?? json['branch_id']?.toString(),
      branchName:
          json['branchName']?.toString() ??
          json['branch_name']?.toString(),
      branchLocation:
          json['branchLocation']?.toString() ??
          json['branch_location']?.toString(),
      branchAddress:
          json['branchAddress']?.toString() ??
          json['branch_address']?.toString(),
      gymClass: gymClass,
    );
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }
}
