// Shared parsing for `membership` on home [`GET /home`] or profile [`GET /customers/profile`].
// Prefers `status == active` when the API returns an array (see API docs).

/// Normalized plan/session fields after parsing `membership` JSON.
class MembershipSnapshot {
  const MembershipSnapshot({
    this.planName,
    this.totalSessions,
    this.sessionsRemaining,
  });

  final String? planName;

  /// Pack size / contract size when provided (e.g. 12-session pack).
  final int? totalSessions;

  /// Sessions left on the entitlement when provided (API: `sessionsRemaining`).
  final int? sessionsRemaining;

  /// True when we have at least one field to show in profile/home UI.
  bool get hasAnyMembershipHint =>
      (planName?.trim().isNotEmpty ?? false) ||
      totalSessions != null ||
      sessionsRemaining != null;

  factory MembershipSnapshot.fromJsonMap(Map<String, dynamic> json) {
    final sessionPack = _toMapOrNull(json['session_pack']);
    return MembershipSnapshot(
      planName: _stringOrNull(
        sessionPack?['planName'] ??
            sessionPack?['plan_name'] ??
            json['planName'] ??
            json['plan_name'] ??
            json['name'],
      ),
      totalSessions: _toIntOrNull(
        sessionPack?['totalSessions'] ??
            sessionPack?['total_sessions'] ??
            json['totalSessions'] ??
            json['total_sessions'],
      ),
      sessionsRemaining: _toIntOrNull(
        sessionPack?['sessionsRemaining'] ??
            sessionPack?['sessions_remaining'] ??
            json['sessionsRemaining'] ??
            json['sessions_remaining'],
      ),
    );
  }
}

/// Parses `membership` when it is a map, or picks the best row from a list.
MembershipSnapshot? parseMembershipField(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map) {
    return MembershipSnapshot.fromJsonMap(Map<String, dynamic>.from(raw));
  }
  if (raw is List) {
    if (raw.isEmpty) return null;
    final maps = raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (maps.isEmpty) return null;
    final chosen = _pickMembershipMap(maps);
    return MembershipSnapshot.fromJsonMap(chosen);
  }
  return null;
}

Map<String, dynamic>? _toMapOrNull(dynamic raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

String? _stringOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

int? _toIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

/// Prefers an active entitlement; otherwise keeps previous behavior (first row).
Map<String, dynamic> _pickMembershipMap(List<Map<String, dynamic>> list) {
  for (final m in list) {
    final s = '${m['status'] ?? ''}'.toLowerCase().trim();
    if (s == 'active') return m;
  }
  return list.first;
}
