/// Subset of profile fields from `POST /auth/login` → `data.user`.
class AuthUser {
  const AuthUser({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString(),
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      lastName: json['last_name'] as String? ?? json['lastName'] as String?,
      name: json['name'] as String? ?? json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

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
}
