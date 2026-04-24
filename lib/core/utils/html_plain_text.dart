import 'package:html/parser.dart' as html_parser;

/// Converts HTML (or entity-encoded text) to a single plain string for UI labels.
String htmlToPlainText(String? raw) {
  if (raw == null) return '';
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';

  final fragment = html_parser.parseFragment(trimmed);
  var out = fragment.text?.trim() ?? '';
  if (out.isEmpty) {
    out = trimmed
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  return out;
}
