import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

class MyBookingsPageResult {
  const MyBookingsPageResult({
    required this.items,
    this.pagination,
  });

  final List<BookingResource> items;
  final PaginationMeta? pagination;
}
