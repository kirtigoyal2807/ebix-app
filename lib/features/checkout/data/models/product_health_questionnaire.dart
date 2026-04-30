import 'product_health_question.dart';

/// Parsed `GET …/questionnaires/product/{id}` or `GET …/questionnaires/{id}` envelope `data`.
class ProductHealthQuestionnaire {
  const ProductHealthQuestionnaire({
    this.questionnaireId,
    this.questions = const [],
  });

  final int? questionnaireId;
  final List<ProductHealthQuestion> questions;

  static int? _parseId(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  /// Supports `data.questionnaires[]`, `data.questionnaire`, `data.questions`, or `data` as a list.
  factory ProductHealthQuestionnaire.fromEnvelopeData(dynamic data) {
    int? questionnaireId;
    final out = <ProductHealthQuestion>[];

    if (data is List) {
      return ProductHealthQuestionnaire(
        questions: data.map(ProductHealthQuestion.fromJson).toList(),
      );
    }

    if (data is! Map) {
      return const ProductHealthQuestionnaire();
    }
    final m = Map<String, dynamic>.from(data);

    final questionnaires = m['questionnaires'];
    if (questionnaires is List && questionnaires.isNotEmpty) {
      final item = questionnaires.first;
      if (item is Map) {
        final qm = Map<String, dynamic>.from(item);
        questionnaireId = _parseId(qm['id']);
        final inner = qm['questions'];
        if (inner is List) {
          out.addAll(inner.map(ProductHealthQuestion.fromJson));
        }
      }
      return ProductHealthQuestionnaire(
        questionnaireId: questionnaireId,
        questions: out,
      );
    }

    final questionnaire = m['questionnaire'];
    if (questionnaire is Map) {
      final qm = Map<String, dynamic>.from(questionnaire);
      questionnaireId = _parseId(qm['id']);
      final inner = qm['questions'];
      if (inner is List) {
        return ProductHealthQuestionnaire(
          questionnaireId: questionnaireId,
          questions: inner.map(ProductHealthQuestion.fromJson).toList(),
        );
      }
    }

    final inner = m['questions'] ?? m['items'] ?? m['data'];
    if (inner is List) {
      return ProductHealthQuestionnaire(
        questionnaireId: questionnaireId,
        questions: inner.map(ProductHealthQuestion.fromJson).toList(),
      );
    }

    return ProductHealthQuestionnaire(
      questionnaireId: questionnaireId,
      questions: out,
    );
  }
}
