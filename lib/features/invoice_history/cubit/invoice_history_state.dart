import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class InvoiceHistoryState extends Equatable {
  final List<InvoiceCategory> invoiceCategoryList;
  final InvoiceCategory selectedInvoiceCategory;



  InvoiceHistoryState({
    required this.invoiceCategoryList,

    this.selectedInvoiceCategory =InvoiceCategory.all,

  });

  InvoiceHistoryState copyWith({
    List<InvoiceCategory>? invoiceCategoryList,
    InvoiceCategory? selectedInvoiceCategory,
    List<String>? sortByList,
    String? selectedSortByValue,
    List<String>? dateRangeList,
  }) {
    return InvoiceHistoryState(
      invoiceCategoryList: invoiceCategoryList ?? this.invoiceCategoryList,
      selectedInvoiceCategory:
          selectedInvoiceCategory ?? this.selectedInvoiceCategory,

    );
  }

  @override
  List<Object> get props => [invoiceCategoryList, selectedInvoiceCategory];
}


enum InvoiceCategory {
  all,
  subscriptions,
  classes,
  refunds,
}