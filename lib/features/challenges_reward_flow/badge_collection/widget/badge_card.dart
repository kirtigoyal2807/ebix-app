import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../cubit/badge_cubit.dart';
import '../cubit/badge_state.dart';
import '../model/badge_model.dart';
import 'badge_sheet.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<BadgeCubit, BadgeState>(
      buildWhen: (previous, current) =>
          previous.badgeDataList != current.badgeDataList,
      builder: (context, state) {
        if (state.badgeDataList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: AppText(
              context.l10n.contentNoDataAvailable,
              style: (c) =>
                  AppTextStyles.bodyLightText(c).copyWith(height: 1.55),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
          ),
          itemCount: state.badgeDataList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = state.badgeDataList[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  barrierColor: AppColors.bottomSheetShadow,

                  builder: (_) => BadgeSheetBottomSheet(
                    imageIcon: isDark ? item.darkImage : item.image,
                    title: getBadgeName(context, item.badgeName),
                  ),
                );
              },
              child: Container(
                height: 142,
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.homeBackground
                      : AppColors.whiteColor,
                  border: Border.all(
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isDark ? item.darkImage : item.image,
                      height: 56,
                      width: 56,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppText(
                      getBadgeName(context, item.badgeName),
                      style: (context) =>
                          AppTextStyles.textFieldHeading(context),
                    ),
                    SizedBox(height: 2),
                    AppText(
                      getStatus(context, item.status),
                      style: (context) => AppTextStyles.bodyLightText(
                        context,
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String getBadgeName(BuildContext context, BadgeData badgeData) {
    switch (badgeData) {
      case BadgeData.februaryStreak:
        return context.l10n.february_streak;
      case BadgeData.studioLegend:
        return context.l10n.studio_legend;
      case BadgeData.firstStep:
        return context.l10n.first_step;
      case BadgeData.earlyBird:
        return context.l10n.early_bird;
      case BadgeData.lotusBlossom:
        return context.l10n.lotus_blossom;
      case BadgeData.coreStrength:
        return context.l10n.core_strength;
      case BadgeData.weekWarrior:
        return context.l10n.week_warrior;
      case BadgeData.balanceMaster:
        return context.l10n.balance_master;
      default:
        return "";
    }
  }

  String getStatus(BuildContext context, BadgeStatus status) {
    switch (status) {
      case BadgeStatus.locked:
        return context.l10n.locked;
      case BadgeStatus.earned:
        return context.l10n.earned;
    }
  }
}
