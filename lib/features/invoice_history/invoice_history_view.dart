import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/invoice_history/view/all_view.dart';
import 'package:pilates_app/features/invoice_history/view/class_view.dart';
import 'package:pilates_app/features/invoice_history/view/refund_view.dart';
import 'package:pilates_app/features/invoice_history/view/subscriptions_view.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';
import 'package:pilates_app/features/invoice_history/widget/filtter_sheet.dart';
import 'package:pilates_app/features/invoice_history/widget/invoice_category_buttons.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../config/theme/app_colors.dart';
import '../../core/localization/localization_extension.dart';
import 'cubit/invoice_history_cubit.dart';
import 'cubit/invoice_history_state.dart';

class InvoiceHistoryView extends StatelessWidget {
  const InvoiceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceHistoryCubit(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.invoiceHistory,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          isMoreMenu: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  barrierColor:     AppColors.bottomSheetShadow,
                  builder: (_) => FilterSelectionBottomSheet(),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            children: [
              InvoiceCategoryButtons(),
              BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
                builder: (context, state) {
                  if (state.selectedInvoiceCategory == InvoiceCategory.all) {
                    return const Expanded(child: AllView());
                  } else if (state.selectedInvoiceCategory ==
                      InvoiceCategory.subscriptions) {
                    return const Expanded(child: SubscriptionsView());
                  } else if (state.selectedInvoiceCategory ==
                      InvoiceCategory.classes) {
                    return const Expanded(child: ClassView());
                  } else if (state.selectedInvoiceCategory ==
                      InvoiceCategory.refunds) {
                    return const Expanded(child: RefundView());
                  }

                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
