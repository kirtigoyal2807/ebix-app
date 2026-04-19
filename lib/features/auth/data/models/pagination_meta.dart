import 'package:equatable/equatable.dart';

/// `meta.pagination` from paginated list responses (Laravel-style).
class PaginationMeta extends Equatable {
  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: _int(json['current_page'] ?? json['currentPage'], 1),
      lastPage: _int(json['last_page'] ?? json['lastPage'], 1),
      perPage: _int(json['per_page'] ?? json['perPage'], 15),
      total: _int(json['total'], 0),
    );
  }

  static int _int(dynamic v, int fallback) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? fallback;
  }

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
