import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/data/models/weekly_activity_result.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/weekly_activity_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/weekly_activity_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';

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
          const WeeklyGraph(),
        ],
      ),
    );
  }
}

class WeeklyGraph extends StatelessWidget {
  const WeeklyGraph({super.key});

  static List<_BarData> _barsFromWeek(
    BuildContext context,
    WeeklyActivityResult? result,
  ) {
    final labels = [
      context.l10n.weekly_day_monday,
      context.l10n.weekly_day_tuesday,
      context.l10n.weekly_day_wednesday,
      context.l10n.weekly_day_thursday,
      context.l10n.weekly_day_friday,
      context.l10n.weekly_day_saturday,
      context.l10n.weekly_day_sunday,
    ];
    final minutes = List<double>.filled(7, 0);
    if (result != null) {
      for (final d in result.week) {
        final dt = DateTime.tryParse(d.date);
        if (dt == null) continue;
        final idx = dt.weekday - 1;
        if (idx >= 0 && idx < 7) {
          minutes[idx] = d.minutes.toDouble();
        }
      }
    } else {
      return [
        _BarData(labels[0], 45),
        _BarData(labels[1], 80),
        _BarData(labels[2], 35),
        _BarData(labels[3], 90),
        _BarData(labels[4], 50),
        _BarData(labels[5], 0),
        _BarData(labels[6], 0),
      ];
    }
    return List.generate(7, (i) => _BarData(labels[i], minutes[i]));
  }

  static double _maxScale(List<_BarData> data) {
    final m = data.fold<double>(0, (a, b) => math.max(a, b.value));
    return m < 1 ? 100.0 : m;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<WeeklyActivityCubit, WeeklyActivityState>(
      builder: (context, state) {
        if (state.status == WeeklyActivityStatus.loading &&
            state.result == null) {
          return Container(
            padding: EdgeInsets.all(AppSpacing.md),
            height: 220,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        final data = _barsFromWeek(context, state.result);
        final maxValue = _maxScale(data);
        final summaryMinutes = state.result?.totalMinutes ?? 0;

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
                        AppText(
                          '${e.value.toInt()}m',
                          style: (context) => AppTextStyles.body(context),
                        ),
                        const SizedBox(height: AppSpacing.sm),
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
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
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
                      text: state.result != null
                          ? ' ${summaryMinutes}m'
                          : context.l10n.weekly_activity_summary,
                      style: AppTextStyles.textFieldHeading(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BarData {
  final String day;
  final double value;

  _BarData(this.day, this.value);
}
