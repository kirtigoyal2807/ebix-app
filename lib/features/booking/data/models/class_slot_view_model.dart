import 'package:pilates_app/features/booking/data/models/class_event_detail.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';
import 'package:pilates_app/features/booking/data/models/review_resource.dart';

/// Flattened UI model: one entry per (class × upcoming-event) pair.
/// Used in the booking list view and passed through to detail / confirm screens.
class ClassSlotViewModel {
  const ClassSlotViewModel({
    required this.classId,
    required this.calendarEventId,
    required this.name,
    this.description,
    this.imageUrl,
    this.avgRating,
    required this.allowPackageBooking,
    required this.allowSinglePurchase,
    required this.trainerName,
    required this.branchName,
    this.branchLocation,
    this.branchAddress,
    required this.startAt,
    required this.endAt,
    this.slotsLeft,
    this.waitlistCount,
    this.durationMinutes,
    this.basePrice,
    this.recentReviews,
  });

  final String classId;
  final String calendarEventId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double? avgRating;
  final bool allowPackageBooking;
  final bool allowSinglePurchase;
  final String trainerName;
  final String branchName;
  final String? branchLocation;
  final String? branchAddress;
  final DateTime startAt;
  final DateTime endAt;
  final int? slotsLeft;
  final int? waitlistCount;
  final int? durationMinutes;
  final double? basePrice;

  /// From `GET /classes` / event detail `class.recentReviews`; null → fetch via `GET /reviews`.
  final List<ReviewResource>? recentReviews;

  bool get isFull => slotsLeft != null && slotsLeft! <= 0;

  bool get upgradeRequired => !allowPackageBooking && !allowSinglePurchase;

  /// Short label for UI when [avgRating] is present (includes `0`); `null` if API omitted rating.
  String? get averageRatingDisplayLabel {
    final r = avgRating;
    if (r == null) return null;
    if (r == r.roundToDouble()) return r.round().toString();
    return r.toStringAsFixed(1);
  }

  /// Build from the flattened GymClassResource + one UpcomingEvent.
  factory ClassSlotViewModel.fromClassAndEvent(
    GymClassResource gymClass,
    UpcomingEvent event,
  ) {
    return ClassSlotViewModel(
      classId: gymClass.id,
      calendarEventId: event.id,
      name: gymClass.name,
      description: gymClass.description,
      imageUrl: gymClass.image,
      avgRating: gymClass.avgRating,
      allowPackageBooking: gymClass.allowPackageBooking,
      allowSinglePurchase: gymClass.allowSinglePurchase,
      trainerName: event.trainerName ?? '',
      branchName: event.branchName,
      branchLocation: event.branchLocation,
      branchAddress: event.branchAddress,
      startAt: event.startAt,
      endAt: event.endAt,
      slotsLeft: event.slotsLeft,
      waitlistCount: event.waitlistCount,
      durationMinutes: gymClass.defaultDurationMinutes,
      basePrice: gymClass.basePrice,
      recentReviews: gymClass.recentReviews,
    );
  }

  /// Build from ClassEventDetail (used in class detail view).
  factory ClassSlotViewModel.fromEventDetail(ClassEventDetail detail) {
    return ClassSlotViewModel(
      classId: detail.gymClass?.id ?? '',
      calendarEventId: detail.eventId,
      name: detail.gymClass?.name ?? '',
      description: detail.gymClass?.description,
      imageUrl: detail.gymClass?.image,
      avgRating: detail.gymClass?.avgRating,
      allowPackageBooking: detail.gymClass?.allowPackageBooking ?? false,
      allowSinglePurchase: detail.gymClass?.allowSinglePurchase ?? false,
      trainerName: detail.trainerName ?? '',
      branchName: detail.branchName ?? '',
      branchLocation: detail.branchLocation,
      branchAddress: detail.branchAddress,
      startAt: detail.startAt,
      endAt: detail.endAt,
      slotsLeft: detail.slotsLeft,
      waitlistCount: detail.waitlistCount,
      durationMinutes: detail.gymClass?.defaultDurationMinutes,
      basePrice: detail.gymClass?.basePrice,
      recentReviews: detail.gymClass?.recentReviews,
    );
  }

  ClassSlotViewModel copyWith({
    String? classId,
    String? calendarEventId,
    String? name,
    String? description,
    String? imageUrl,
    double? avgRating,
    bool? allowPackageBooking,
    bool? allowSinglePurchase,
    String? trainerName,
    String? branchName,
    String? branchLocation,
    String? branchAddress,
    DateTime? startAt,
    DateTime? endAt,
    int? slotsLeft,
    int? waitlistCount,
    int? durationMinutes,
    double? basePrice,
    List<ReviewResource>? recentReviews,
  }) {
    return ClassSlotViewModel(
      classId: classId ?? this.classId,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      avgRating: avgRating ?? this.avgRating,
      allowPackageBooking: allowPackageBooking ?? this.allowPackageBooking,
      allowSinglePurchase: allowSinglePurchase ?? this.allowSinglePurchase,
      trainerName: trainerName ?? this.trainerName,
      branchName: branchName ?? this.branchName,
      branchLocation: branchLocation ?? this.branchLocation,
      branchAddress: branchAddress ?? this.branchAddress,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      slotsLeft: slotsLeft ?? this.slotsLeft,
      waitlistCount: waitlistCount ?? this.waitlistCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      basePrice: basePrice ?? this.basePrice,
      recentReviews: recentReviews ?? this.recentReviews,
    );
  }
}
