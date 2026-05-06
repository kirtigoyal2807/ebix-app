import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_overview_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_overview_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_radius.dart';

class GoalProgress extends StatelessWidget {
  const GoalProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<ProgressOverviewCubit, ProgressOverviewState>(
      builder: (context, state) {
        if (state.status == ProgressOverviewStatus.loading &&
            state.overview == null) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        final overview = state.overview;
        final pct = overview == null
            ? 0.0
            : (overview.goalPercent / 100).clamp(0.0, 1.0);
        final pctLabel = overview == null
            ? '—'
            : '${overview.goalPercent.round()}%';
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryDarkButton
                : AppColors.seekBarLight,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                context.l10n.goal_progress_title,
                style: (context) =>
                    AppTextStyles.experienceButton(context).copyWith(height: 1),
              ),
              SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 200,
                width: 167,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 3.1416,
                      child: CircularProgressIndicator(
                        value: overview == null ? null : pct,
                        backgroundColor: isDark
                            ? AppColors.progressBGColor
                            : AppColors.darkGreyBorder,
                        constraints: const BoxConstraints(
                          minHeight: 167,
                          minWidth: 167,
                          maxHeight: 167,
                          maxWidth: 167,
                        ),
                        strokeWidth: 16,
                        valueColor: AlwaysStoppedAnimation(
                          isDark
                              ? AppColors.languageIconDark
                              : AppColors.languageIcon,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          pctLabel,
                          style: (context) =>
                              AppTextStyles.headline(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText,
                              ),
                        ),
                        SizedBox(height: 2),
                        AppText(
                          context.l10n.goal_progress_complete,
                          style: (context) =>
                              AppTextStyles.textField(context).copyWith(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              AppText(
                context.l10n.goal_progress_sessions,
                style: (context) =>
                    AppTextStyles.textFieldHeading(context).copyWith(height: 1),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Icon(
                    Icons.radar,
                    size: 16,
                    color: isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon,
                  ),
                  AppText(
                    overview == null
                        ? context.l10n.goal_progress_remaining
                        : '${overview.mtdAttendedClasses} / ${overview.goal}',
                    style: (context) => AppTextStyles.captionText(
                      context,
                    ).copyWith(color: AppColors.lightGrey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
