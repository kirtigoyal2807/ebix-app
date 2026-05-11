/// Rules for date-of-birth inputs: minimum registrable age for pickers and validation.
abstract final class DateOfBirthConstraints {
  DateOfBirthConstraints._();

  static const int minimumAgeYears = 16;

  /// Latest calendar birth date for someone who is at least [minimumAgeYears]
  /// old on [referenceDay] (date-only semantics).
  static DateTime latestSelectableBirthDate(DateTime referenceDay) {
    final ref = DateTime(
      referenceDay.year,
      referenceDay.month,
      referenceDay.day,
    );
    return DateTime(ref.year - minimumAgeYears, ref.month, ref.day);
  }

  static DateTime clampToSelectableRange(
    DateTime candidate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    final d = DateTime(candidate.year, candidate.month, candidate.day);
    if (d.isBefore(firstDate)) return firstDate;
    if (d.isAfter(lastDate)) return lastDate;
    return d;
  }

  /// True when [dateOfBirth] is on or before [latestSelectableBirthDate] for [referenceDay].
  static bool satisfiesMinimumAge(DateTime dateOfBirth, DateTime referenceDay) {
    final d = DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day);
    return !d.isAfter(latestSelectableBirthDate(referenceDay));
  }
}
