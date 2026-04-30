/// One question from the health questionnaire API.
///
/// Envelope `data` may be:
/// - a list of questions,
/// - `{ "questions": [...] }`,
/// - `{ "questionnaires": [ { "questions": [...] }, ... ] }` — e.g.
///   `GET health-intake/questionnaires/product/{productId}`,
/// - `{ "questionnaire": { "questions": [...] } }` — e.g.
///   `GET health-intake/questionnaires/{questionnaireId}`.
class ProductHealthQuestion {
  const ProductHealthQuestion({
    this.id,
    this.key,
    this.label,
    this.title,
    this.type,
    this.options,
    this.isRequired,
    this.allowOther,
    this.order,
  });

  final String? id;
  final String? key;
  final String? label;
  final String? title;
  final String? type;
  final List<String>? options;
  final bool? isRequired;
  final bool? allowOther;
  final int? order;

  String get displayLabel => (label ?? title ?? key ?? id ?? '').trim();

  int? get numericQuestionId => int.tryParse(id ?? '');

  bool get isBooleanQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'boolean' || t == 'bool';
  }

  factory ProductHealthQuestion.fromJson(dynamic json) {
    if (json is! Map) {
      return const ProductHealthQuestion();
    }
    final m = Map<String, dynamic>.from(json);
    List<String>? opts;
    final o = m['options'] ?? m['choices'];
    if (o is List) {
      opts = o
          .map((e) {
            if (e is Map) {
              final om = Map<String, dynamic>.from(e);
              final v = om['label'] ?? om['value'] ?? om['text'] ?? om['id'];
              return v?.toString() ?? '';
            }
            return e.toString();
          })
          .where((s) => s.trim().isNotEmpty)
          .toList();
      if (opts.isEmpty) opts = null;
    }
    final text =
        m['text'] as String? ?? m['label'] as String? ?? m['question'] as String?;
    return ProductHealthQuestion(
      id: m['id']?.toString(),
      key: m['key'] as String? ?? m['fieldKey'] as String?,
      label: text,
      title: m['title'] as String?,
      type: m['type'] as String? ?? m['inputType'] as String?,
      options: opts,
      isRequired: m['required'] as bool? ?? m['isRequired'] as bool?,
      allowOther: m['allowOther'] as bool?,
      order: _readInt(m['order'] ?? m['sortOrder']),
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
