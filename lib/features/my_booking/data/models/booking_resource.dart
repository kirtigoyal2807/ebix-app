/// Single enrollment from `GET /my-bookings` (BookingResource in API spec).
class BookingResource {
  const BookingResource({
    required this.id,
    required this.status,
    required this.statusLabel,
    this.waitlistPosition,
    required this.className,
    required this.trainerName,
    required this.branchName,
    this.startAt,
    this.endAt,
    this.classImageUrl,
    this.checkedInAt,
    this.cancelledAt,
  });

  final String id;
  final String status;
  final String statusLabel;
  final int? waitlistPosition;
  final String className;
  final String trainerName;
  final String branchName;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? classImageUrl;

  /// Set when the customer has checked in at the branch (API §13.11).
  final DateTime? checkedInAt;

  /// Set after successful cancel (API §13.10).
  final DateTime? cancelledAt;

  factory BookingResource.fromJson(Map<String, dynamic> json) {
    final classMap = _map(json['class']);
    final eventMap = _map(json['event']);
    final branchMap = _map(eventMap?['branch']);
    final trainerMap = _map(eventMap?['trainer']);

    return BookingResource(
      id: '${json['id'] ?? ''}',
      status: '${json['status'] ?? ''}',
      statusLabel: '${json['statusLabel'] ?? json['status_label'] ?? ''}',
      waitlistPosition: _intOrNull(json['waitlistPosition'] ?? json['waitlist_position']),
      className: '${classMap?['name'] ?? ''}',
      trainerName: '${trainerMap?['name'] ?? ''}',
      branchName: '${branchMap?['name'] ?? ''}',
      startAt: _date(eventMap?['startAt'] ?? eventMap?['start_at']),
      endAt: _date(eventMap?['endAt'] ?? eventMap?['end_at']),
      classImageUrl: _stringOrNull(classMap?['image'] ?? classMap?['imageUrl']),
      checkedInAt: _date(json['checkedInAt'] ?? json['checked_in_at']),
      cancelledAt: _date(json['cancelledAt'] ?? json['cancelled_at']),
    );
  }

  static Map<String, dynamic>? _map(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  static DateTime? _date(dynamic v) {
    if (v == null) return null;
    if (v is String && v.isNotEmpty) {
      return DateTime.tryParse(v);
    }
    return null;
  }

  static String? _stringOrNull(dynamic v) {
    if (v is String && v.isNotEmpty) return v;
    return null;
  }
}
