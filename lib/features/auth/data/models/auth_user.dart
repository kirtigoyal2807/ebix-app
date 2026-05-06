import 'package:pilates_app/core/models/membership_snapshot.dart';

/// Subset of profile fields from `POST /auth/login` → `data.user`, or [`GET /me`].
class AuthUser {
  const AuthUser({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.dateOfBirth,

    /// From `membership[]` / `planName` on profile (aligned with [`GET /home`] `membership`).
    this.membershipPlanName,

    /// From `membership[].totalSessions` or top-level helpers when backend sends them.
    this.membershipTotalSessions,

    /// From `membership[].sessionsRemaining` (`sessionsRemaining`) when provided.
    this.membershipSessionsRemaining,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;

  /// From profile / login payload when the API sends `dob`, `date_of_birth`, etc.
  final DateTime? dateOfBirth;

  final String? membershipPlanName;
  final int? membershipTotalSessions;
  final int? membershipSessionsRemaining;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final membershipSnap = parseMembershipField(json['membership']);
    return AuthUser(
      id: json['id']?.toString(),
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      lastName: json['last_name'] as String? ?? json['lastName'] as String?,
      name: json['name'] as String? ?? json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      dateOfBirth: _parseDateOfBirth(
        json['dob'] ??
            json['date_of_birth'] ??
            json['dateOfBirth'] ??
            json['birth_date'],
      ),
      membershipPlanName:
          membershipSnap?.planName ??
          _trimOrNull(json['membershipPlanName']) ??
          _trimOrNull(json['planName']) ??
          _trimOrNull(json['plan_name']),
      membershipTotalSessions:
          membershipSnap?.totalSessions ??
          _parseInt(json['membershipTotalSessions']) ??
          _parseInt(json['totalSessions']) ??
          _parseInt(json['total_sessions']),
      membershipSessionsRemaining:
          membershipSnap?.sessionsRemaining ??
          _parseInt(json['membershipSessionsRemaining']) ??
          _parseInt(json['sessionsRemaining']) ??
          _parseInt(json['sessions_remaining']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'name': name,
    'email': email,
    'phone': phone,
    if (dateOfBirth != null)
      'dob': dateOfBirth!.toIso8601String().split('T').first,
    'membershipPlanName': membershipPlanName,
    'membershipTotalSessions': membershipTotalSessions,
    'membershipSessionsRemaining': membershipSessionsRemaining,
  };

  int? get ageYears {
    final d = dateOfBirth;
    if (d == null) return null;
    final now = DateTime.now();
    var age = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) {
      age--;
    }
    return age;
  }

  bool get _hasStoredMembershipHints =>
      (membershipPlanName?.trim().isNotEmpty ?? false) ||
      membershipTotalSessions != null ||
      membershipSessionsRemaining != null;

  /// Fallback when [`GET /home`] omits membership but [`GET /me`] carries plan info.
  bool get showsMembershipWithoutHomePayload => _hasStoredMembershipHints;

  /// First name for greetings (home header, etc.).
  String get greetingName {
    final f = firstName?.trim();
    if (f != null && f.isNotEmpty) return f;
    final n = name?.trim();
    if (n != null && n.isNotEmpty) return n.split(RegExp(r'\s+')).first;
    final e = email?.trim();
    if (e != null && e.isNotEmpty) return e.split('@').first;
    final p = phone?.trim();
    if (p != null && p.isNotEmpty) return p;
    return '';
  }

  static String? _trimOrNull(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateOfBirth(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }
}
