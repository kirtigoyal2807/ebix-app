import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/invoice_resource.dart';

/// `GET /invoices` — customer invoice list (Pilates API).
///
/// Response shape (envelope `data` may be a list **or** `{ "data": [ ... ] }`).
class InvoicesRepository extends BaseRepository {
  InvoicesRepository(super.dio);

  /// Loads all pages the API returns in one list (add query params here if the backend supports filtering).
  Future<ApiResult<List<InvoiceResource>>> listInvoices() {
    return get<List<InvoiceResource>>(
      'invoices',
      fromJson: (json) => _parseInvoiceList(json),
    );
  }

  static List<InvoiceResource> _parseInvoiceList(dynamic json) {
    final list = _asInvoiceRowList(json);
    return list
        .map((e) {
          if (e is Map<String, dynamic>) return InvoiceResource.fromJson(e);
          if (e is Map) {
            return InvoiceResource.fromJson(Map<String, dynamic>.from(e));
          }
          return null;
        })
        .whereType<InvoiceResource>()
        .toList();
  }

  /// Unwraps envelope `data` whether it is a [List] or nested `data: [...]`.
  static List<dynamic> _asInvoiceRowList(dynamic json) {
    if (json is List) return json;
    if (json is! Map) return [];
    final m = Map<String, dynamic>.from(json);
    final inner = m['data'];
    if (inner is List) return inner;
    if (inner is Map) {
      final d = inner['data'];
      if (d is List) return d;
    }
    return [];
  }
}
