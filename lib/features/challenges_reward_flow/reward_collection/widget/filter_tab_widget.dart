import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../cubit/reward_cubit.dart';
import '../cubit/reward_state.dart';

class FilterTabButton extends StatelessWidget {
  const FilterTabButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<RewardCubit, RewardState>(
      builder: (context, state) {
        return SizedBox(
          height: 28,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: state.rewardFilterList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected =
                  state.selectedRewardFilter == state.rewardFilterList[index];

              return GestureDetector(
                onTap: () {
                  context.read<RewardCubit>().setSelectedFilterType(
                    state.rewardFilterList[index],
                  );
                },
                child: Container(
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
                    getLabel(context, state.rewardFilterList[index]),
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

  String getLabel(BuildContext context, RewardFilter type) {
    switch (type) {
      case RewardFilter.all:
        return context.l10n.all;
      case RewardFilter.experiences:
        return context.l10n.experiences;
      case RewardFilter.classes:
        return context.l10n.classes;
      case RewardFilter.discounts:
        return context.l10n.discounts;
    }
  }
}
