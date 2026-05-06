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
    final root = _effectiveEnrollmentMap(json);
    final classMap = _map(root['class']);
    final eventMap = _map(root['event']);
    final branchMap = _map(eventMap?['branch']);
    final trainerMap = _map(eventMap?['trainer']);

    return BookingResource(
      id: _enrollmentIdFrom(root),
      status: '${root['status'] ?? ''}',
      statusLabel: '${root['statusLabel'] ?? root['status_label'] ?? ''}',
      waitlistPosition: _waitlistPositionFrom(root),
      className: '${classMap?['name'] ?? ''}',
      trainerName: '${trainerMap?['name'] ?? ''}',
      branchName: '${branchMap?['name'] ?? ''}',
      startAt: _date(eventMap?['startAt'] ?? eventMap?['start_at']),
      endAt: _date(eventMap?['endAt'] ?? eventMap?['end_at']),
      classImageUrl: _stringOrNull(classMap?['image'] ?? classMap?['imageUrl']),
      checkedInAt: _date(root['checkedInAt'] ?? root['checked_in_at']),
      cancelledAt: _date(root['cancelledAt'] ?? root['cancelled_at']),
    );
  }

  /// Prefer nested payload when API wraps enrollment (`data.enrollment`) per §13 patterns.
  static Map<String, dynamic> _effectiveEnrollmentMap(
    Map<String, dynamic> json,
  ) {
    final nested = _map(json['enrollment']) ?? _map(json['booking']);
    if (nested != null && nested.isNotEmpty) {
      return nested;
    }
    final data = _map(json['data']);
    if (data != null && data.isNotEmpty) {
      final inner = _map(data['enrollment']) ?? _map(data['booking']);
      if (inner != null && inner.isNotEmpty) {
        return inner;
      }
      return data;
    }
    return json;
  }

  static String _enrollmentIdFrom(Map<String, dynamic> root) {
    final candidates = <dynamic>[
      root['id'],
      root['enrollmentId'],
      root['enrollment_id'],
      root['uuid'],
      root['enrollmentUUID'],
      root['enrollment_uuid'],
    ];
    for (final c in candidates) {
      if (c == null) continue;
      final s = '$c'.trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  static int? _waitlistPositionFrom(Map<String, dynamic> root) {
    final direct = _intOrNull(
      root['waitlistPosition'] ??
          root['waitlist_position'] ??
          root['position'] ??
          root['queuePosition'] ??
          root['queue_position'],
    );
    if (direct != null) return direct;

    final eventMap = _map(root['event']);
    if (eventMap != null) {
      return _intOrNull(
        eventMap['waitlistPosition'] ?? eventMap['waitlist_position'],
      );
    }
    return null;
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
