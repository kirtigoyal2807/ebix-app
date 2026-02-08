import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingTabs extends StatelessWidget {
  const BookingTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              _TabItem(
                label: context.l10n.classesNav,
                isSelected: state.selectedTab == BookingTab.classes,
                onTap: () => context.read<BookingCubit>().setTab(BookingTab.classes),
              ),
              _TabItem(
                label: context.l10n.trainers,
                isSelected: state.selectedTab == BookingTab.trainers,
                onTap: () => context.read<BookingCubit>().setTab(BookingTab.trainers),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = (isDark ? AppColors.darkGreyBorder : AppColors.primary);
    final inactiveColor = isDark ? AppColors.lightGrey : AppColors.lightGrey;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? activeColor : isDark ? AppColors.greyText : AppColors.buttonBorder,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: AppText(
              label,
              style:  (context) => AppTextStyles.boldBody(context).copyWith(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600:FontWeight.w400,
                color: isSelected ? (isDark ? AppColors.languageTextDark : AppColors.languageIcon) : inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
