import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/auth/data/models/branch.dart';

/// Branch row for rewards filtering — lines up with `GET /branches` plus an
/// “all locations” synthetic row (`id <= 0`).
class BranchModel extends Equatable {
  const BranchModel({
    required this.id,
    required this.title,
    required this.rewardsCount,
  });

  final int id;
  final String title;
  final int rewardsCount;

  factory BranchModel.fromBranch(Branch branch) {
    final parts = [branch.title.trim(), branch.city.trim()]
        .where((s) => s.isNotEmpty)
        .toList();
    final displayTitle = parts.join(', ');
    return BranchModel(
      id: branch.id,
      title: displayTitle.isNotEmpty ? displayTitle : branch.title,
      rewardsCount: branch.rewardsCount,
    );
  }

  @override
  List<Object?> get props => [id, title, rewardsCount];
}
