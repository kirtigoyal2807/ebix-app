import 'package:pilates_app/core/constants/api_config.dart';

/// Turns API-relative paths into absolute URLs for [Image.network] / [NetworkImage].
///
/// Many payloads return `/storage/...` or `storage/...` while [ApiConfig.baseUrl] is
/// `https://host/api/v1/` — raw strings then fail to load and the UI falls back to placeholders.
String? resolveApiMediaUrl(String? raw) {
  final t = raw?.trim();
  if (t == null || t.isEmpty) return null;
  if (t.startsWith('http://') || t.startsWith('https://')) return t;
  final baseUri = Uri.parse(ApiConfig.baseUrl);
  if (t.startsWith('//')) {
    return '${baseUri.scheme}:$t';
  }
  return baseUri.resolve(t).toString();
}
