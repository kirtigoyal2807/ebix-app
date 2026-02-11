import 'package:flutter/material.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';

import '../../../core/localization/localization_extension.dart';

class ClassView extends StatelessWidget {
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EmptyDataView(
      title: context.l10n.noClassesYet,
      subTitle: context.l10n.classInvoiceSubtitle,
      image: isDark
          ? "assets/images/svg/invoice_history/ic_dark_no_class.svg"
          : "assets/images/svg/invoice_history/ic_no_class.svg",
    );
  }
}
