import 'package:bloc/bloc.dart';

import 'package:pilates_app/features/invoice_history/cubit/invoice_history_state.dart';
import 'package:pilates_app/features/invoice_history/data/invoices_repository.dart';
import 'package:pilates_app/features/invoice_history/data/models/invoice_resource.dart';

class InvoiceHistoryCubit extends Cubit<InvoiceHistoryState> {
  InvoiceHistoryCubit(this._invoicesRepository)
      : super(
          InvoiceHistoryState(
            invoiceCategoryList: InvoiceCategory.values,
          ),
        ) {
    refresh();
  }

  final InvoicesRepository _invoicesRepository;

  /// Client-side filter on `GET /invoices` rows ([InvoiceResource.type] / [InvoiceResource.status]).
  static bool _matchesTab(InvoiceResource row, InvoiceCategory category) {
    final t = row.type.toLowerCase();
    final st = row.status.toLowerCase();
    switch (category) {
      case InvoiceCategory.all:
        return true;
      case InvoiceCategory.subscriptions:
        return t.contains('subscription');
      case InvoiceCategory.classes:
        return t.contains('class_purchase') ||
            t == 'classes' ||
            (t.contains('class') && !t.contains('subscription'));
      case InvoiceCategory.refunds:
        return t.contains('refund') || st == 'refunded';
    }
  }

  Future<void> refresh() => _load(state.selectedInvoiceCategory);

  Future<void> setSelectedInvoiceCategory(InvoiceCategory category) async {
    if (category == state.selectedInvoiceCategory &&
        state.loadStatus == InvoicesLoadStatus.success) {
      return;
    }
    emit(state.copyWith(selectedInvoiceCategory: category));
    await _load(category);
  }

  Future<void> _load(InvoiceCategory category) async {
    emit(
      state.copyWith(
        loadStatus: InvoicesLoadStatus.loading,
        clearError: true,
      ),
    );

    final result = await _invoicesRepository.listInvoices();
    result.when(
      success: (rows, _) {
        final filtered = rows.where((r) => _matchesTab(r, category)).toList()
          ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
        final items = filtered;
        emit(
          state.copyWith(
            loadStatus: InvoicesLoadStatus.success,
            invoices: items,
            pagination: null,
            clearError: true,
          ),
        );
      },
      failure: (e) {
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
