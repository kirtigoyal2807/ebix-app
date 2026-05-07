import 'package:equatable/equatable.dart';

/// `/branches` list item — maps common API field names.
class Branch extends Equatable {
  const Branch({
    required this.id,
    required this.title,
    required this.city,
    required this.distance,
    required this.typeLabel,
    this.lat,
    this.lng,
    this.imageUrl,
    this.isActive = true,
    this.rewardsCount = 0,
  });

  final int id;
  final String title;
  final String city;
  final String distance;
  final String typeLabel;
  final double? lat;
  final double? lng;
  final String? imageUrl;
  final bool isActive;
  final int rewardsCount;

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: _asInt(json['id']),
      title: _string(json['name'] ?? json['title'] ?? json['branch_name']),
      city: _cityFromJson(json),
      distance: _string(json['distance_label'] ?? json['distance'] ?? json['km_away']),
      typeLabel: _typeLabelFromJson(json),
      lat: _asDouble(json['lat'] ?? json['latitude']),
      lng: _asDouble(json['lng'] ?? json['longitude']),
      imageUrl: _nullableString(
        json['image_url'] ?? json['imageUrl'] ?? json['image'] ?? json['photo'],
      ),
      isActive: json['isActive'] as bool? ?? json['active'] as bool? ?? true,
      rewardsCount: _asInt(json['rewardsCount'] ?? json['rewards_count']),
    );
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static String _string(dynamic v) {
    if (v == null) return '';
    final s = '$v'.trim();
    return s;
  }

  /// Prefer structured city/address; avoid using `location` when it is a maps URL.
  static String _cityFromJson(Map<String, dynamic> json) {
    final direct = _string(
      json['city'] ?? json['city_name'] ?? json['address'],
    );
    if (direct.isNotEmpty) return direct;
    final loc = _string(json['location']);
    if (loc.isNotEmpty && !_isProbablyUrl(loc)) return loc;
    return '';
  }

  static bool _isProbablyUrl(String s) {
    final t = s.trim().toLowerCase();
    if (t.startsWith('http://') || t.startsWith('https://')) return true;
    if (t.contains('maps.app') || t.contains('goo.gl')) return true;
    return false;
  }

  static String _typeLabelFromJson(Map<String, dynamic> json) {
    final type = _string(
      json['branchLabel'] ??
          json['branch_label'] ??
          json['type'] ??
          json['branch_type'] ??
          json['tier'] ??
          json['label'],
    );
    if (type.isNotEmpty) return type;
    final branchType = _string(json['branchType'] ?? json['branch_type']);
    if (branchType.isNotEmpty) return branchType;
    return 'Studio';
  }

  static String? _nullableString(dynamic v) {
    if (v == null) return null;
    final s = '$v'.trim();
    return s.isEmpty ? null : s;
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  @override
  List<Object?> get props =>
      [id, title, city, distance, typeLabel, lat, lng, imageUrl, isActive, rewardsCount];
}
