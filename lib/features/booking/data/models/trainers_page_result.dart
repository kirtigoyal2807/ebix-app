import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';

import 'trainer_resource.dart';

/// One page from `GET /trainers` (§12.1).
class TrainersPageResult {
  const TrainersPageResult({required this.items, this.pagination});

  final List<TrainerResource> items;
  final PaginationMeta? pagination;
}
