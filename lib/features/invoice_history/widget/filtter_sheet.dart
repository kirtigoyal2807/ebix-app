import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/invoice_history/cubit/filter_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/filter_cubit.dart';

class FilterSelectionBottomSheet extends StatelessWidget {
  const FilterSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider(
      create: (context) => FilterCubit(),
      child: Material(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  right: AppSpacing.base
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
              const SizedBox(height: AppSpacing.xi),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.sortBy,
                  style: (context) => AppTextStyles.experienceButton(
                    context,
                  ).copyWith(color: AppColors.lightGrey, height: 1.55),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: state.sortByList.length,
                      itemBuilder: (context, index) {
                        final option = state.sortByList[index];
                        final isSelected = option == state.selectedSortByValue;
                        return _OptionTile(
                          label: getSortByLabel(context, option),
                          isSelected: isSelected,
                          onTap: () {
                            context.read<FilterCubit>().setSelectedSortBy(
                              option,
                            );
                            // onSelect(option);
                            // Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.dateRange,
                  style: (context) => AppTextStyles.experienceButton(
                    context,
                  ).copyWith(color: AppColors.lightGrey, height: 1.55),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: state.dateRangeList.length,
                      itemBuilder: (context, index) {
                        final option = state.dateRangeList[index];
                        final isSelected = option == state.selectedDateRange;
                        return _OptionTile(
                          label: getDateRangeLabel(context, option),
                          isSelected: isSelected,
                          onTap: () {
                            context.read<FilterCubit>().setSelectedDateRange(
                              option,
                            );
                            // onSelect(option);
                            // Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
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
          padding: const EdgeInsets.only(
            // horizontal: AppSpacing.md,
            bottom: 10,
          ),
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          // decoration: BoxDecoration(
          //   color: isSelected
          //       ? (isDark
          //             ? AppColors.primaryDarkButton
          //             : AppColors.selectedLanguageBg)
          //       : Colors.transparent,
          //   borderRadius: BorderRadius.circular(AppRadius.lg),
          // ),
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
