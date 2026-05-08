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
  final withoutLeadingSlash = t.startsWith('/') ? t.substring(1) : t;
  if (withoutLeadingSlash.startsWith('customers/avatars/')) {
    return baseUri.resolve('/storage/$withoutLeadingSlash').toString();
  }
  // Payloads often return site-root paths without a leading slash (e.g.
  // `customers/avatars/…`). Resolving those against `…/api/v1/` yields
  // `…/api/v1/customers/avatars/…`, which 404s for static files.
  final rootPath = t.startsWith('/') ? t : '/$t';
  return baseUri.resolve(rootPath).toString();
}
