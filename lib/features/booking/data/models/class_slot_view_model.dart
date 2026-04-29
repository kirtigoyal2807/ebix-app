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
    this.gender,
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

  /// Gender restriction for this event: 'Male', 'Female', or null (all genders).
  final String? gender;

  bool get isFull => slotsLeft != null && slotsLeft! <= 0;

  /// `true` when the user can book or join waitlist for a concrete calendar event.
  bool get hasBookableSlot => calendarEventId.trim().isNotEmpty;

  /// Upgrade required when class is not included in user's current package.
  bool get upgradeRequired => !allowPackageBooking;

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
      gender: event.gender,
    );
  }

  /// Picks an [UpcomingEvent] from [gymClass]: [preferredEventId] if listed, else earliest by [UpcomingEvent.startAt].
  static UpcomingEvent? pickUpcomingEvent(
    GymClassResource gymClass,
    String? preferredEventId,
  ) {
    final events = gymClass.upcomingEvents;
    if (events.isEmpty) return null;
    final want = preferredEventId?.trim();
    if (want != null && want.isNotEmpty) {
      for (final e in events) {
        if (e.id == want) return e;
      }
    }
    final sorted = List<UpcomingEvent>.from(events)
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    return sorted.first;
  }

  /// Build from `GET /classes/{classId}` ([GymClassResource]). When [event] is null, class
  /// metadata is shown without a bookable session ([hasBookableSlot] is false).
  factory ClassSlotViewModel.fromGymClassResource(
    GymClassResource gymClass, {
    UpcomingEvent? event,
  }) {
    if (event != null) {
      return ClassSlotViewModel.fromClassAndEvent(gymClass, event);
    }
    return ClassSlotViewModel(
      classId: gymClass.id,
      calendarEventId: '',
      name: gymClass.name,
      description: gymClass.description,
      imageUrl: gymClass.image,
      avgRating: gymClass.avgRating,
      allowPackageBooking: gymClass.allowPackageBooking,
      allowSinglePurchase: gymClass.allowSinglePurchase,
      trainerName: '',
      branchName: '',
      branchLocation: null,
      branchAddress: null,
      startAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      endAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      slotsLeft: null,
      waitlistCount: null,
      durationMinutes: gymClass.defaultDurationMinutes,
      basePrice: gymClass.basePrice,
      recentReviews: gymClass.recentReviews,
      gender: null,
    );
  }

  /// Build from §13.5 `GET /classes/events/{eventId}` when needed outside class-detail.
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
      gender: detail.gender,
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
    String? gender,
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
      gender: gender ?? this.gender,
    );
  }
}
