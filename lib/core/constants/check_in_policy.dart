/// Client-side schedule for physical check-in: opens [kOpensBeforeStart]
/// minutes before class [startAt]; closes when the session [endAt] is reached,
/// or at [startAt] if [endAt] is unknown.
///
/// Hardcoded policy (no API toggle) agreed with stakeholders.
abstract final class CheckInPolicy {
  static const Duration kOpensBeforeStart = Duration(minutes: 30);

  /// Absolute local instant when check-in unlocks — [classStart] may be UTC.
  static DateTime opensAt(DateTime classStart) {
    final startLocal = classStart.toLocal();
    return startLocal.subtract(kOpensBeforeStart);
  }

  /// Last instant check-in stays allowed — inclusive of [closesAt]'s minute.
  static DateTime closesAt(DateTime classStart, DateTime? classEndUtcOrNull) {
    final startLocal = classStart.toLocal();
    final endUtc = classEndUtcOrNull ?? classStart;
    final closeLocal = endUtc.toLocal();
    if (!closeLocal.isBefore(startLocal)) return closeLocal;
    return startLocal;
  }

  /// Eligible strictly by wall-clock vs class times (caller must still gate on
  /// enrollment status — booked, etc.).
  static bool nowIsWithinWindow({
    required DateTime nowLocal,
    required DateTime classStartUtcOrLocal,
    DateTime? classEndUtcOrLocal,
  }) {
    final band = timeBandFor(
      nowLocal: nowLocal,
      classStartUtcOrLocal: classStartUtcOrLocal,
      classEndUtcOrLocal: classEndUtcOrLocal,
    );
    return band == CheckInTimeBand.inWindow;
  }

  static CheckInTimeBand timeBandFor({
    required DateTime nowLocal,
    required DateTime classStartUtcOrLocal,
    DateTime? classEndUtcOrLocal,
  }) {
    final open = opensAt(classStartUtcOrLocal);
    final close = closesAt(classStartUtcOrLocal, classEndUtcOrLocal);
    if (close.isBefore(open)) {
      final safeClose = open;
      final n = nowLocal.millisecondsSinceEpoch;
      final o = open.millisecondsSinceEpoch;
      final c = safeClose.millisecondsSinceEpoch;
      if (n < o) return CheckInTimeBand.tooEarly;
      if (n > c) return CheckInTimeBand.tooLate;
      return CheckInTimeBand.inWindow;
    }

    final n = nowLocal;
    if (n.isBefore(open)) return CheckInTimeBand.tooEarly;
    if (n.isAfter(close)) return CheckInTimeBand.tooLate;
    return CheckInTimeBand.inWindow;
  }
}

enum CheckInTimeBand {
  tooEarly,
  inWindow,
  tooLate,
}
