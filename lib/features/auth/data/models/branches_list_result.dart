import 'package:equatable/equatable.dart';

import 'branch.dart';
import 'pagination_meta.dart';

class BranchesListResult extends Equatable {
  const BranchesListResult({
    required this.branches,
    this.pagination,
  });

  final List<Branch> branches;
  final PaginationMeta? pagination;

  @override
  List<Object?> get props => [branches, pagination];
}
