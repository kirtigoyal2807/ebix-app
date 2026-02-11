import 'package:flutter/material.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';

import '../../../core/localization/localization_extension.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EmptyDataView(
      title: context.l10n.noSubscriptionsYet,
      subTitle: context.l10n.noSubscriptionsSubtitle,
      image: isDark
          ? "assets/images/svg/invoice_history/ic_dark_no_subscription.svg"
          : "assets/images/svg/invoice_history/ic_no_subscription.svg",
    );
  }
}
