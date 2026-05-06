/// One selectable row from API `options[]` when entries are objects
/// (`value`, `text`, …). [value] is stored in answers and sent to the backend;
/// [label] is shown in the UI.
class ProductHealthQuestionOption {
  const ProductHealthQuestionOption({required this.value, required this.label});

  final String value;
  final String label;
}

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
    this.section,
    this.options,
    this.optionChoices,
    this.isRequired,
    this.allowOther,
    this.order,
  });

  final String? id;
  final String? key;
  final String? label;
  final String? title;
  final String? type;

  /// API grouping, e.g. `personal_information`, `medical` (from `section` / `group` / `category`).
  final String? section;

  /// Submission tokens (e.g. checkbox answer list, radio value). Prefer
  /// [resolvedOptionRows] for UI when [optionChoices] is set.
  final List<String>? options;

  /// When API sends `{ "text", "value" }` per option, labels differ from values.
  final List<ProductHealthQuestionOption>? optionChoices;
  final bool? isRequired;
  final bool? allowOther;
  final int? order;

  String get displayLabel => (label ?? title ?? key ?? id ?? '').trim();

  int? get numericQuestionId => int.tryParse(id ?? '');

  /// Checkbox / radio rows: [optionChoices] if present, else one row per [options] string.
  List<ProductHealthQuestionOption> get resolvedOptionRows {
    if (optionChoices != null && optionChoices!.isNotEmpty) {
      return optionChoices!;
    }
    final o = options;
    if (o == null || o.isEmpty) return const [];
    return [
      for (final v in o)
        if (v.trim().isNotEmpty)
          ProductHealthQuestionOption(value: v, label: v),
    ];
  }

  bool get isBooleanQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'boolean' || t == 'bool';
  }

  bool get isCheckboxQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'checkbox' ||
        t == 'check_box' ||
        t == 'multi_select' ||
        t == 'multiselect';
  }

  bool get isRadioQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'radio' ||
        t == 'single_select' ||
        t == 'select' ||
        t == 'dropdown';
  }

  bool get isFreeTextQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'text' || t == 'textarea' || t == 'string';
  }

  bool get isNumericInputQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'number' || t == 'integer' || t == 'decimal' || t == 'numeric';
  }

  bool get isEmailInputQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'email';
  }

  bool get isPhoneInputQuestion {
    final t = type?.toLowerCase().trim();
    return t == 'phone' || t == 'tel' || t == 'mobile';
  }

  /// Open-ended inputs rendered on the personal-information step when driven by the API.
  bool get isPersonalInformationInputType {
    return isFreeTextQuestion ||
        isNumericInputQuestion ||
        isEmailInputQuestion ||
        isPhoneInputQuestion;
  }

  static String? _normalizeToken(String? raw) {
    if (raw == null) return null;
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return null;
    return s.replaceAll(RegExp(r'[\s_-]'), '');
  }

  /// Maps API `key` / `id` tokens to [SubscriptionState] personal fields (`name`, `age`, …).
  /// When non-null, this question must not be sent in `answers[]` on health-intake.
  String? get personalInformationStateSlot {
    for (final candidate in <String?>[key, id]) {
      final norm = _normalizeToken(candidate);
      if (norm == null) continue;
      switch (norm) {
        case 'fullname':
        case 'name':
        case 'firstname':
        case 'customername':
          return 'name';
        case 'age':
          return 'age';
        case 'height':
        case 'heightcm':
        case 'heightincm':
          return 'height';
        case 'weight':
        case 'weightkg':
        case 'weightinkg':
          return 'weight';
        case 'phonenumber':
        case 'phone':
        case 'mobile':
        case 'mobilenumber':
          return 'phoneNumber';
        case 'email':
        case 'emailaddress':
          return 'email';
      }
    }
    return null;
  }

  bool get isPersonalInformationSection {
    final s = section?.toLowerCase().trim() ?? '';
    return s.contains('personal') ||
        s.contains('demographic') ||
        s.contains('profile');
  }

  /// Whether this item is collected as `personalInformation.*` instead of `answers[]`.
  bool get isPersonalInformationEnvelopeField {
    if (!isPersonalInformationInputType) return false;
    if (personalInformationStateSlot != null) return true;
    return isPersonalInformationSection;
  }

  /// Storage key for [SubscriptionState.personalInformationDynamicFields] when the
  /// question is not mapped to a fixed name/age/… slot.
  String get dynamicPersonalStorageKey {
    if (key != null && key!.trim().isNotEmpty) return key!.trim();
    if (numericQuestionId != null) return 'field_$numericQuestionId';
    return 'field_${id ?? 'unknown'}';
  }

  /// Some APIs require non-empty `answers[].answerNote` for boolean `true` even when
  /// [allowOther] is false (no explain field in the UI). Use this as the fallback text.
  String defaultAnswerNoteForBooleanYes() {
    final t = displayLabel.trim();
    if (t.isEmpty) {
      return 'Yes';
    }
    if (t.length <= 240) {
      return t;
    }
    return '${t.substring(0, 237)}...';
  }

  factory ProductHealthQuestion.fromJson(dynamic json) {
    if (json is! Map) {
      return const ProductHealthQuestion();
    }
    final m = Map<String, dynamic>.from(json);
    List<String>? flatOpts;
    List<ProductHealthQuestionOption>? choiceRows;
    final o = m['options'] ?? m['choices'];
    if (o is List) {
      flatOpts = [];
      choiceRows = [];
      for (final e in o) {
        if (e is Map) {
          final om = Map<String, dynamic>.from(e);
          final value =
              (om['value'] ?? om['id'] ?? om['text'])?.toString().trim() ?? '';
          if (value.isEmpty) continue;
          final rawLabel = (om['text'] ?? om['label'] ?? om['value'])
              ?.toString()
              .trim();
          final display = (rawLabel != null && rawLabel.isNotEmpty)
              ? rawLabel
              : value;
          flatOpts.add(value);
          choiceRows.add(
            ProductHealthQuestionOption(value: value, label: display),
          );
        } else {
          final s = e.toString().trim();
          if (s.isEmpty) continue;
          flatOpts.add(s);
          choiceRows.add(ProductHealthQuestionOption(value: s, label: s));
        }
      }
      if (flatOpts.isEmpty) {
        flatOpts = null;
        choiceRows = null;
      }
    }
    final text =
        m['text'] as String? ??
        m['label'] as String? ??
        m['question'] as String?;
    return ProductHealthQuestion(
      id: m['id']?.toString(),
      key: m['key'] as String? ?? m['fieldKey'] as String?,
      label: text,
      title: m['title'] as String?,
      type: m['type'] as String? ?? m['inputType'] as String?,
      section:
          m['section'] as String? ??
          m['group'] as String? ??
          m['category'] as String?,
      options: flatOpts,
      optionChoices: choiceRows,
      isRequired: _readBool(m['required']) ?? _readBool(m['isRequired']),
      allowOther: _readBool(m['allowOther']),
      order: _readInt(m['order'] ?? m['sortOrder']),
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static bool? _readBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().trim().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
    return null;
  }
}

/// Questions rendered on the personal-information step (API-driven demographics).
List<ProductHealthQuestion> personalInformationQuestionsFromApi(
  List<ProductHealthQuestion> all,
) {
  final filtered = all
      .where((q) => q.isPersonalInformationEnvelopeField)
      .toList();
  int sortKey(ProductHealthQuestion q) => q.order ?? q.numericQuestionId ?? 0;
  filtered.sort((a, b) => sortKey(a).compareTo(sortKey(b)));
  return filtered;
}

/// API personal fields not mapped to the fixed name/age/height/weight/phone/email inputs.
List<ProductHealthQuestion> extraPersonalInformationQuestionsFromApi(
  List<ProductHealthQuestion> all,
) {
  return personalInformationQuestionsFromApi(
    all,
  ).where((q) => q.personalInformationStateSlot == null).toList();
}
