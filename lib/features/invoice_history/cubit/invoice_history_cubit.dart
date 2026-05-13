import 'package:bloc/bloc.dart';

import 'package:pilates_app/features/invoice_history/cubit/filter_state.dart';
import 'package:pilates_app/features/invoice_history/cubit/invoice_history_state.dart';
import 'package:pilates_app/features/invoice_history/data/invoices_repository.dart';
import 'package:pilates_app/features/invoice_history/data/models/invoice_resource.dart';

class InvoiceHistoryCubit extends Cubit<InvoiceHistoryState> {
  InvoiceHistoryCubit(this._invoicesRepository)
    : super(InvoiceHistoryState(invoiceCategoryList: InvoiceCategory.values)) {
    refresh();
  }

  final InvoicesRepository _invoicesRepository;

  List<InvoiceResource> _rawInvoices = [];

  /// Client-side filter on `GET /invoices` rows ([InvoiceResource.type] / [InvoiceResource.status]).
  ///
  /// Avoid treating missing API `type` as subscription (that made every row match “Subscriptions”).
  static bool _looksLikeSubscriptionInvoice(String typeLower, String titleLower) {
    if (typeLower.contains('subscription') ||
        typeLower.contains('membership') ||
        typeLower.contains('member_ship') ||
        typeLower.contains('recurring') ||
        typeLower.contains('renewal')) {
      return true;
    }
    return titleLower.contains('subscription') ||
        titleLower.contains('membership') ||
        titleLower.contains('renewal');
  }

  static bool _matchesTab(InvoiceResource row, InvoiceCategory category) {
    final t = row.type.toLowerCase().trim();
    final title = row.title.toLowerCase();

    switch (category) {
      case InvoiceCategory.all:
        return true;
      case InvoiceCategory.subscriptions:
        if (row.isRefund || row.amount < 0) return false;
        if (_isClassLikeInvoice(t, title)) return false;
        if (t.isNotEmpty) {
          return t.contains('subscription') ||
              t.contains('membership') ||
              t.contains('member_ship') ||
              t.contains('recurring') ||
              t.contains('renewal');
        }
        return title.contains('subscription') ||
            title.contains('membership') ||
            title.contains('renewal');
      case InvoiceCategory.classes:
        if (_looksLikeSubscriptionInvoice(t, title)) return false;
        return _isClassLikeInvoice(t, title);
      case InvoiceCategory.refunds:
        return row.isRefund || row.amount < 0;
    }
  }

  static bool _isClassLikeInvoice(String typeLower, String titleLower) {
    if (typeLower.contains('class_purchase') ||
        typeLower.contains('class purchase')) {
      return true;
    }
    if (typeLower == 'classes') return true;
    if (typeLower.contains('booking')) return true;
    if (typeLower.contains('session') && !typeLower.contains('subscription')) {
      return true;
    }
    if (typeLower.contains('class') && !typeLower.contains('subscription')) {
      return true;
    }
    if (typeLower.isEmpty &&
        (titleLower.contains('class') ||
            titleLower.contains('booking') ||
            titleLower.contains('session'))) {
      return true;
    }
    return false;
  }

  static bool _inDateRange(DateTime issuedAt, DateRange range) {
    if (range == DateRange.allTime) return true;
    final local = issuedAt.toLocal();
    final issueDay = DateTime(local.year, local.month, local.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case DateRange.last30Days:
        return !issueDay.isBefore(today.subtract(const Duration(days: 30)));
      case DateRange.last3Months:
        return !issueDay.isBefore(today.subtract(const Duration(days: 92)));
      case DateRange.last6Months:
        return !issueDay.isBefore(today.subtract(const Duration(days: 183)));
      case DateRange.thisYear:
        return local.year == now.year;
      case DateRange.allTime:
        return true;
    }
  }

  static void _applySort(List<InvoiceResource> rows, SortBy sort) {
    switch (sort) {
      case SortBy.newest:
        rows.sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
      case SortBy.oldest:
        rows.sort((a, b) => a.issuedAt.compareTo(b.issuedAt));
      case SortBy.priceHighToLow:
        rows.sort((a, b) => b.amount.compareTo(a.amount));
      case SortBy.priceLowToHigh:
        rows.sort((a, b) => a.amount.compareTo(b.amount));
    }
  }

  void _reproject() {
    // Re-apply filters whenever cached rows exist — including while a refresh is
    // in-flight ([InvoicesLoadStatus.loading]), so sort/date changes are not ignored.
    if (_rawInvoices.isEmpty) {
      if (state.loadStatus == InvoicesLoadStatus.success) {
        emit(state.copyWith(invoices: const [], clearError: true));
      }
      return;
    }

    if (state.loadStatus == InvoicesLoadStatus.failure ||
        state.loadStatus == InvoicesLoadStatus.initial) {
      return;
    }

    var rows = _rawInvoices
        .where((r) => _matchesTab(r, state.selectedInvoiceCategory))
        .where((r) => _inDateRange(r.issuedAt, state.dateRange))
        .toList();
    _applySort(rows, state.sortBy);
    emit(state.copyWith(invoices: rows, clearError: true));
  }

  Future<void> refresh() => _fetchAndCache();

  void setSortBy(SortBy value) {
    if (value == state.sortBy) return;
    emit(state.copyWith(sortBy: value));
    _reproject();
  }

  void setDateRange(DateRange value) {
    if (value == state.dateRange) return;
    emit(state.copyWith(dateRange: value));
    _reproject();
  }

  Future<void> setSelectedInvoiceCategory(InvoiceCategory category) async {
    if (category == state.selectedInvoiceCategory &&
        state.loadStatus == InvoicesLoadStatus.success) {
      return;
    }
    emit(state.copyWith(selectedInvoiceCategory: category));
    if (_rawInvoices.isEmpty) {
      await _fetchAndCache();
    } else {
      _reproject();
    }
  }

  Future<void> _fetchAndCache() async {
    emit(
      state.copyWith(loadStatus: InvoicesLoadStatus.loading, clearError: true),
    );

    final result = await _invoicesRepository.listInvoices();
    result.when(
      success: (rows, _) {
        _rawInvoices = List<InvoiceResource>.from(rows);
        emit(
          state.copyWith(
            loadStatus: InvoicesLoadStatus.success,
            clearError: true,
          ),
        );
        _reproject();
      },
      failure: (e) {
        _rawInvoices = [];
        emit(
          state.copyWith(
            loadStatus: InvoicesLoadStatus.failure,
            invoices: const [],
            errorMessage: e.message,
          ),
        );
      },
    );
  }
}
