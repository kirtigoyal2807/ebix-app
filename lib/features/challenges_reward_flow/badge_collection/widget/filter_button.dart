import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../cubit/badge_cubit.dart';
import '../cubit/badge_state.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<BadgeCubit, BadgeState>(
      builder: (context, state) {
        return SizedBox(
          height: 28,

          child: ListView.separated(
            itemCount: state.badgeList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected = state.selectedBadge == state.badgeList[index];

              return GestureDetector(
                onTap: () {
                  context.read<BadgeCubit>().setSelectedBadgeType(
                    state.badgeList[index],
                  );
                },
                child: Container(
                  width: 74,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isDark
                        ? Colors.transparent
                        : AppColors.greyContainerBg,
                    borderRadius: BorderRadius.circular(AppRadius.base),
                  ),
                  child: AppText(
                    getBadgeLabel(context, state.badgeList[index]),
                    style: (context) =>
                        AppTextStyles.textFieldHeading(context).copyWith(
                          color: isSelected || isDark
                              ? Colors.white
                              : AppColors.darkText,
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

  String getBadgeLabel(BuildContext context, BadgeType type) {
    switch (type) {
      case BadgeType.all:
        return context.l10n.all;
      case BadgeType.bronze:
        return context.l10n.badge_bronze;
      case BadgeType.silver:
        return context.l10n.badge_silver;
      case BadgeType.gold:
        return context.l10n.badge_gold;
    }
  }
}
