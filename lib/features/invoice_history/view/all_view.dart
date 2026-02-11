import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';

import '../../../core/localization/localization_extension.dart';
import '../widget/invoice_history_card.dart';

class AllView extends StatelessWidget {
  const AllView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    return
    //   EmptyDataView(
    //   title: context.l10n.noInvoicesYet,
    //   subTitle: context.l10n.invoiceHistorySubtitle,
    //   image: isDark
    //       ? "assets/images/svg/invoice_history/ic_dark_no_invoice.svg"
    //       : "assets/images/svg/invoice_history/ic_no_invoice.svg",
    // );
    Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          InvoiceHistoryCard(
            month: DateFormat.yMMMM(locale)
                .format(DateTime(2026, 1)),
            title: "Premium Plan",
            amount: '\$89',
            subTitle:context.l10n.invoiceNumber("INV-2026-001"),
            date: DateFormat.yMMMd(locale)
                .format(DateTime(2026, 1, 15)),
          ),
          SizedBox(height: AppSpacing.md),
          InvoiceHistoryCard(
            month: DateFormat.yMMMM(locale)
                .format(DateTime(2026, 2)),
            title: "Basic Plan",
            amount: '\$45',
            subTitle: context.l10n.invoiceNumber("#INV-2025-012"),
            date: DateFormat.yMMMd(locale)
                .format(DateTime(2026, 12, 15)),
          ),
        ],
      ),
    );
  }
}
