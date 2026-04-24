import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';

import 'review_resource.dart';

class ReviewsListResult {
  const ReviewsListResult({
    required this.items,
    this.pagination,
  });

  final List<ReviewResource> items;
  final PaginationMeta? pagination;
}
