enum MyBookingsStatusGroup {
  upcoming,
  current,
  past,
  cancelled;

  /// `status_group` for `GET /my-bookings` (e.g. `upcoming`, `cancelled`).
  /// If the cancelled tab is always empty but the API uses US spelling, change to
  /// `canceled` only for [MyBookingsStatusGroup.cancelled].
  String get apiValue => name;

  int get tabIndex => MyBookingsStatusGroup.values.indexOf(this);
}
