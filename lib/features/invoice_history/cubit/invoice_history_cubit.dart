import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'invoice_history_state.dart';

class InvoiceHistoryCubit extends Cubit<InvoiceHistoryState> {
  InvoiceHistoryCubit()
    : super(
        InvoiceHistoryState(
          invoiceCategoryList: InvoiceCategory.values,
        ),
      );


  void setSelectedInvoiceCategory(InvoiceCategory category) {
    emit(state.copyWith(selectedInvoiceCategory: category));
  }
}




