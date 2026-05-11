import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/invoice_history/data/invoices_repository.dart';
import 'package:pilates_app/features/invoice_history/widget/filtter_sheet.dart';
import 'package:pilates_app/features/invoice_history/widget/invoice_category_buttons.dart';
import 'package:pilates_app/features/invoice_history/widget/invoice_list_panel.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../config/theme/app_colors.dart';
import '../../core/localization/localization_extension.dart';
import 'cubit/invoice_history_cubit.dart';

class InvoiceHistoryView extends StatelessWidget {
  const InvoiceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InvoiceHistoryCubit(context.read<InvoicesRepository>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppAppBar(
              title: context.l10n.invoiceHistory,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    final cubit = context.read<InvoiceHistoryCubit>();
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: AppColors.bottomSheetShadow,
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const FilterSelectionBottomSheet(),
                      ),
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
              child: const Column(
                children: [
                  InvoiceCategoryButtons(),
                  Expanded(child: InvoiceListPanel()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
