import 'package:equatable/equatable.dart';

/// `/branches` list item — maps common API field names.
class Branch extends Equatable {
  const Branch({
    required this.id,
    required this.title,
    required this.city,
    required this.distance,
    required this.typeLabel,
  });

  final int id;
  final String title;
  final String city;
  final String distance;
  final String typeLabel;

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: _asInt(json['id']),
      title: _string(json['name'] ?? json['title'] ?? json['branch_name']),
      city: _string(json['city'] ?? json['city_name'] ?? json['address']),
      distance: _string(json['distance_label'] ?? json['distance'] ?? json['km_away']),
      typeLabel: _string(
        json['type'] ?? json['branch_type'] ?? json['tier'] ?? json['label'] ?? 'Standard',
      ),
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

  @override
  List<Object?> get props => [id, title, city, distance, typeLabel];
}
