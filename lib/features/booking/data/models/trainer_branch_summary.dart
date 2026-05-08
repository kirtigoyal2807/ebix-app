/// Pilates API §12 — branch summary on trainer resources.
class TrainerBranchSummary {
  const TrainerBranchSummary({required this.id, required this.name});

  final String id;
  final String name;

  factory TrainerBranchSummary.fromJson(Map<String, dynamic> json) {
    return TrainerBranchSummary(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
    );
  }
}
