import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/invoice_history/cubit/filter_state.dart';
import 'package:pilates_app/features/invoice_history/data/models/invoice_resource.dart';

enum InvoicesLoadStatus { initial, loading, success, failure }

class InvoiceHistoryState extends Equatable {
  const InvoiceHistoryState({
    required this.invoiceCategoryList,
    this.selectedInvoiceCategory = InvoiceCategory.all,
    this.loadStatus = InvoicesLoadStatus.initial,
    this.invoices = const [],
    this.errorMessage,
    this.pagination,
    this.sortBy = SortBy.newest,

    /// Default matches previous behavior when filters were not applied (full history).
    this.dateRange = DateRange.allTime,
  });

  final List<InvoiceCategory> invoiceCategoryList;
  final InvoiceCategory selectedInvoiceCategory;
  final InvoicesLoadStatus loadStatus;
  final List<InvoiceResource> invoices;
  final String? errorMessage;
  final PaginationMeta? pagination;
  final SortBy sortBy;
  final DateRange dateRange;

  InvoiceHistoryState copyWith({
    List<InvoiceCategory>? invoiceCategoryList,
    InvoiceCategory? selectedInvoiceCategory,
    InvoicesLoadStatus? loadStatus,
    List<InvoiceResource>? invoices,
    String? errorMessage,
    PaginationMeta? pagination,
    SortBy? sortBy,
    DateRange? dateRange,
    bool clearError = false,
  }) {
    return InvoiceHistoryState(
      invoiceCategoryList: invoiceCategoryList ?? this.invoiceCategoryList,
      selectedInvoiceCategory:
          selectedInvoiceCategory ?? this.selectedInvoiceCategory,
      loadStatus: loadStatus ?? this.loadStatus,
      invoices: invoices ?? this.invoices,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pagination: pagination ?? this.pagination,
      sortBy: sortBy ?? this.sortBy,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  @override
  List<Object?> get props => [
    invoiceCategoryList,
    selectedInvoiceCategory,
    loadStatus,
    invoices,
    errorMessage,
    pagination,
    sortBy,
    dateRange,
  ];
}

enum InvoiceCategory { all, subscriptions, classes, refunds }
