import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import 'filter_selection_bottom_sheet.dart';

class BookingFilterChips extends StatelessWidget {
  const BookingFilterChips({super.key});

  void _showFilter(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selectedOption,
    required Function(String) onSelect,
    required String Function(String) labelBuilder,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.bottomSheetShadow,
      builder: (_) => FilterSelectionBottomSheet(
        title: title,
        options: options,
        selectedOption: selectedOption,
        onSelect: onSelect,
        labelBuilder: labelBuilder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _FilterChip(
                label: state.selectedDate == 'Today'
                    ? context.l10n.today
                    : _getDateLabel(context, state.selectedDate),
                isSelected: state.selectedDate != 'Today',
                onTap: () => _showFilter(
                  context,
                  title: context.l10n.date,
                  options: [
                    'Today',
                    'Tomorrow',
                    'This Week',
                    'Next Week',
                    'This Weekend',
                    'All Dates',
                  ],
                  selectedOption: state.selectedDate,
                  onSelect: cubit.setDate,
                  labelBuilder: (opt) => _getDateLabel(context, opt),
                ),
                onClear: () => cubit.setDate('Today'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: state.selectedCategory == 'All Categories'
                    ? context.l10n.allCategories
                    : state.selectedCategory,
                isSelected: state.selectedCategory != 'All Categories',
                onTap: () => _showFilter(
                  context,
                  title: context.l10n.category,
                  options: [
                    'All Categories',
                    'Power Pilates',
                    'Mat Pilates',
                    'Reformer',
                    'Gentle Strech',
                  ],
                  selectedOption: state.selectedCategory,
                  onSelect: cubit.setCategory,
                  labelBuilder: (opt) => _getCategoryLabel(context, opt),
                ),
                onClear: () => cubit.setCategory('All Categories'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: state.selectedGender == 'All Gender'
                    ? context.l10n.allGender
                    : _getGenderLabel(context, state.selectedGender),
                isSelected: state.selectedGender != 'All Gender',
                onTap: () => _showFilter(
                  context,
                  title: context.l10n.gender,
                  options: ['All Gender', 'Male', 'Female'],
                  selectedOption: state.selectedGender,
                  onSelect: cubit.setGender,
                  labelBuilder: (opt) => _getGenderLabel(context, opt),
                ),
                onClear: () => cubit.setGender('All Gender'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: state.selectedBranch == 'All Branches'
                    ? context.l10n.allBranches
                    : state.selectedBranch,
                isSelected: state.selectedBranch != 'All Branches',
                onTap: () => _showFilter(
                  context,
                  title: context.l10n.branch,
                  options: [
                    'All Branches',
                    'Branch 1',
                    'Branch 2',
                    'Branch 3',
                    'Branch 4',
                    'Branch 5',
                  ],
                  selectedOption: state.selectedBranch,
                  onSelect: cubit.setBranch,
                  labelBuilder: (opt) => _getBranchLabel(context, opt),
                ),
                onClear: () => cubit.setBranch('All Branches'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDateLabel(BuildContext context, String opt) {
    switch (opt) {
      case 'Today':
        return context.l10n.today;
      case 'Tomorrow':
        return context.l10n.tomorrow;
      case 'This Week':
        return context.l10n.thisWeek;
      case 'Next Week':
        return context.l10n.nextWeek;
      case 'This Weekend':
        return context.l10n.thisWeekend;
      case 'All Dates':
        return context.l10n.allDates;
      default:
        return opt;
    }
  }

  String _getCategoryLabel(BuildContext context, String opt) {
    if (opt == 'All Categories') return context.l10n.allCategories;
    return opt;
  }

  String _getGenderLabel(BuildContext context, String opt) {
    switch (opt) {
      case 'Male':
        return context.l10n.male;
      case 'Female':
        return context.l10n.female;
      case 'All Gender':
        return context.l10n.allGender;
      default:
        return opt;
    }
  }

  String _getBranchLabel(BuildContext context, String opt) {
    switch (opt) {
      case 'All Branches':
        return context.l10n.allBranches;
      case 'Branch 1':
        return context.l10n.branch1;
      case 'Branch 2':
        return context.l10n.branch2;
      case 'Branch 3':
        return context.l10n.branch3;
      case 'Branch 4':
        return context.l10n.branch4;
      case 'Branch 5':
        return context.l10n.branch5;
      default:
        return opt;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool isSelected;

  const _FilterChip({
    required this.label,
    required this.onTap,
    required this.onClear,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.homeBackground : AppColors.whiteColor),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected
                ? (isDark
                      ? AppColors.darkGreyBorder
                      : AppColors.splashBackgroundDark)
                : (isDark ? AppColors.greyText : AppColors.buttonBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              style: (context) =>
                  AppTextStyles.bodyTextSmall(
                    context,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ).copyWith(
                    color: isSelected
                        ? (isDark
                              ? AppColors.languageTextDark
                              : AppColors.languageIcon)
                        : (isDark ? AppColors.lightText : AppColors.darkText),
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            if (isSelected)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: isDark
                      ? AppColors.languageIconDark
                      : AppColors.languageIcon,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              ),
          ],
        ),
      ),
    );
  }
}
