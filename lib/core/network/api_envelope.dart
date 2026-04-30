/// Parses the standard API JSON envelope:
/// `{ "success": true, "message": "...", "data": ... }`
/// `{ "success": false, "message": "...", "errors": { "field": ["msg"] } }`
abstract final class ApiEnvelopeParser {
  /// Dio / JSON decode often yields `Map<dynamic, dynamic>`, not `Map<String, dynamic>` —
  /// checking [Map] avoids silently skipping valid envelopes.
  static bool looksLikeEnvelope(dynamic data) {
    return data is Map && data.containsKey('success');
  }

  /// When [looksLikeEnvelope] is true, returns structured fields; otherwise null.
  static ApiEnvelopeShape? tryParse(dynamic data) {
    if (!looksLikeEnvelope(data)) return null;
    final map = Map<String, dynamic>.from(data as Map);
    final success = map['success'] == true;
    final message = map['message'] as String? ?? '';
    return ApiEnvelopeShape(
      success: success,
      message: message,
      data: map['data'],
      fieldErrors: _normalizeErrors(map['errors']),
      meta: _normalizeMeta(map['meta']),
    );
  }

  static List<dynamic>? _normalizeMeta(dynamic meta) {
    if (meta == null) return null;
    if (meta is List) return List<dynamic>.from(meta);
    return <dynamic>[meta];
  }

  static Map<String, List<String>>? _normalizeErrors(dynamic errors) {
    if (errors == null) return null;
    if (errors is! Map) return null;
    final out = <String, List<String>>{};
    for (final entry in errors.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is List) {
        out[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        out[key] = [value];
      } else {
        out[key] = [value.toString()];
      }
    }
    return out.isEmpty ? null : out;
  }
}

class ApiEnvelopeShape {
  const ApiEnvelopeShape({
    required this.success,
    required this.message,
    required this.data,
    this.fieldErrors,
    this.meta,
  });

  final bool success;
  final String message;
  final dynamic data;
  final Map<String, List<String>>? fieldErrors;

  /// Top-level envelope `meta` (parallel to `data`), when the API sends it.
  final List<dynamic>? meta;
}
