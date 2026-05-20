import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../cubit/invoice_history_cubit.dart';
import '../cubit/invoice_history_state.dart';

class InvoiceCategoryButtons extends StatelessWidget {
  const InvoiceCategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 28,
          child: ListView.separated(
            itemCount: state.invoiceCategoryList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected =
                  state.selectedInvoiceCategory ==
                  state.invoiceCategoryList[index];

              return Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<InvoiceHistoryCubit>()
                        .setSelectedInvoiceCategory(
                          state.invoiceCategoryList[index],
                        );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isDark
                          ? AppColors.primaryDarkButton
                          : AppColors.greyContainerBg,
                      borderRadius: BorderRadius.circular(AppRadius.base),
                    ),
                    child: AppText(
                      getCategoryLabel(
                        context,
                        state.invoiceCategoryList[index],
                      ),
                      maxLines: 1,
                      style: (context) =>
                          AppTextStyles.textFieldHeading(context).copyWith(
                            height: 1,
                            color: isSelected || isDark
                                ? Colors.white
                                : AppColors.darkText,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String getCategoryLabel(BuildContext context, InvoiceCategory category) {
    switch (category) {
      case InvoiceCategory.all:
        return context.l10n.all;
      case InvoiceCategory.subscriptions:
        return context.l10n.subscriptions;
      case InvoiceCategory.classes:
        return context.l10n.classes;
      case InvoiceCategory.refunds:
        return context.l10n.refunds;
    }
  }
}
