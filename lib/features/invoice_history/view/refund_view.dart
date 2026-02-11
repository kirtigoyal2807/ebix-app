import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';

import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/localization_extension.dart';
import '../widget/invoice_history_card.dart';

class RefundView extends StatelessWidget {
  const RefundView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    // return EmptyDataView(
    // title: context.l10n.noRefundsYet,
    // subTitle: context.l10n.noRefundsSubtitle,
    //   image: isDark
    //       ? "assets/images/svg/invoice_history/ic_dark_no_refund.svg"
    //       : "assets/images/svg/invoice_history/ic_no_refund.svg",
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          InvoiceHistoryCard(
            month: DateFormat.yMMMM(locale).format(DateTime(2026, 2)),
            title: "Refund - Class Cancelled",
            amount: '+\$25',
            subTitle: context.l10n.invoiceNumber("#INV-2026-001"),
            date: DateFormat.yMMMd(locale).format(DateTime(2026, 12, 15)),
            refund: true,
          ),
        ],
      ),
    );
  }
}
