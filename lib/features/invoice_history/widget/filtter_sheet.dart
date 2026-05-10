import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/invoice_history/cubit/filter_state.dart';
import 'package:pilates_app/features/invoice_history/cubit/invoice_history_cubit.dart';
import 'package:pilates_app/features/invoice_history/cubit/invoice_history_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class FilterSelectionBottomSheet extends StatelessWidget {
  const FilterSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
                right: AppSpacing.base,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      context.l10n.filters,
                      style: AppTextStyles.bottomSheetTitle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.lightGrey
                          : AppColors.darkGreyText,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xi),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppText(
                context.l10n.sortBy,
                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(color: AppColors.lightGrey, height: 1.55),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: SortBy.values.length,
                  itemBuilder: (context, index) {
                    final option = SortBy.values[index];
                    final isSelected = option == state.sortBy;
                    return _OptionTile(
                      label: getSortByLabel(context, option),
                      isSelected: isSelected,
                      onTap: () {
                        context.read<InvoiceHistoryCubit>().setSortBy(option);
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppText(
                context.l10n.dateRange,
                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(color: AppColors.lightGrey, height: 1.55),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: DateRange.values.length,
                  itemBuilder: (context, index) {
                    final option = DateRange.values[index];
                    final isSelected = option == state.dateRange;
                    return _OptionTile(
                      label: getDateRangeLabel(context, option),
                      isSelected: isSelected,
                      onTap: () {
                        context.read<InvoiceHistoryCubit>().setDateRange(
                          option,
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  label,
                  style: (context) => AppTextStyles.body(context).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: isDark
                      ? AppColors.languageIconDark
                      : AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String getSortByLabel(BuildContext context, SortBy value) {
  switch (value) {
    case SortBy.newest:
      return context.l10n.newest;
    case SortBy.oldest:
      return context.l10n.oldest;
    case SortBy.priceHighToLow:
      return context.l10n.priceHighToLow;
    case SortBy.priceLowToHigh:
      return context.l10n.priceLowToHigh;
  }
}

String getDateRangeLabel(BuildContext context, DateRange value) {
  switch (value) {
    case DateRange.last30Days:
      return context.l10n.last30Days;
    case DateRange.last3Months:
      return context.l10n.last3Months;
    case DateRange.last6Months:
      return context.l10n.last6Months;
    case DateRange.thisYear:
      return context.l10n.thisYear;
    case DateRange.allTime:
      return context.l10n.allTime;
  }
}
