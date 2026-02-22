import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../core/localization/localization_extension.dart';

class WeeklyActivity extends StatelessWidget {
  const WeeklyActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            context.l10n.weekly_activity_title,
            style: (context) => AppTextStyles.gelasioRegular(context),
          ),
          SizedBox(height: AppSpacing.md),
          WeeklyGraph(),
        ],
      ),
    );
  }
}

class WeeklyGraph extends StatelessWidget {
  const WeeklyGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = [
      _BarData(context.l10n.weekly_day_monday, 45),
      _BarData(context.l10n.weekly_day_tuesday, 80),
      _BarData(context.l10n.weekly_day_wednesday, 35),
      _BarData(context.l10n.weekly_day_thursday, 90),
      _BarData(context.l10n.weekly_day_friday, 50),
      _BarData(context.l10n.weekly_day_saturday, 0),
      _BarData(context.l10n.weekly_day_sunday, 0),
    ];

    final maxValue = 100.0; // for scaling

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        children: [
          /// GRAPH
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.map((e) {
                final barHeight = (e.value / maxValue) * 130;

                final isZero = e.value == 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// VALUE TEXT
                    AppText(
                      "${e.value}m",
                      style: (context) => AppTextStyles.body(context),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    /// BAR
                    Container(
                      width: 33,
                      height: isZero ? 20 : barHeight,
                      decoration: BoxDecoration(
                        color: isDark
                            ? (isZero
                                  ? AppColors.lightBlackColor
                                  : AppColors.primary)
                            : (isZero
                                  ? AppColors.darkGreyBorder
                                  : AppColors.primary),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    /// DAY LABEL
                    AppText(
                      e.day,
                      style: (context) =>
                          AppTextStyles.captionText(context).copyWith(
                            color: isDark
                                ? (isZero
                                      ? AppColors.lightDarkGrey
                                      : AppColors.lightText)
                                : (isZero
                                      ? AppColors.languageTextDark
                                      : AppColors.darkText),
                          ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// DIVIDER
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),

          const SizedBox(height: AppSpacing.md),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.l10n.weekly_activity_mindful_movement,
                  style: AppTextStyles.bodyText(context).copyWith(height: 1.55),
                ),
                TextSpan(
                  text:context.l10n.weekly_activity_summary,
                  style: AppTextStyles.textFieldHeading(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String day;
  final double value;

  _BarData(this.day, this.value);
}
