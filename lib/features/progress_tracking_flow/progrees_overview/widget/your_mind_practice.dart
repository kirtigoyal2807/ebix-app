import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_overview_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_overview_state.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';

class YourMindPractice extends StatelessWidget {
  const YourMindPractice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressOverviewCubit, ProgressOverviewState>(
      builder: (context, state) {
        if (state.status == ProgressOverviewStatus.loading &&
            state.overview == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.mind_practice_title,
                  style: (context) => AppTextStyles.gelasioRegular(context),
                ),
                SizedBox(height: AppSpacing.md),
                const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: const AppLoadingIndicator(),
                ),
              ],
            ),
          );
        }

        final overview = state.overview;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final emptyLabel = context.l10n.contentNoDataAvailable;
        final mindfulTitle = overview == null
            ? emptyLabel
            : _formatMindfulHours(context, overview.mtdAttendedMinutes);
        final morningTitle = overview == null
            ? emptyLabel
            : '${overview.mtdMorningSessions}';
        final flowTitle = overview == null
            ? emptyLabel
            : '${overview.flowInstructors}';
        final peaceTitle = overview == null
            ? emptyLabel
            : _formatInnerPeacePercent(overview.innerPeacePercent);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText(
                context.l10n.mind_practice_title,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildCard(
                      isDark: isDark,
                      title: mindfulTitle,
                      subTitle: context.l10n.mind_practice_mindful_movement,
                      iconImage:
                          "assets/images/svg/progress_tracking/ic_mindful_movement.svg",
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildCard(
                      isDark: isDark,
                      title: morningTitle,
                      subTitle: context.l10n.mind_practice_morning_sessions,
                      iconImage:
                          "assets/images/svg/progress_tracking/ic_morning_sessions.svg",
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildCard(
                      isDark: isDark,
                      title: flowTitle,
                      subTitle: context.l10n.mind_practice_flow_instructors,
                      iconImage:
                          "assets/images/svg/progress_tracking/ic_flow_instructors.svg",
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildCard(
                      isDark: isDark,
                      title: peaceTitle,
                      subTitle: context.l10n.mind_practice_inner_peace,
                      iconImage:
                          "assets/images/svg/progress_tracking/ic_inner_peace.svg",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatMindfulHours(BuildContext context, int minutes) {
    if (minutes <= 0) {
      return context.l10n.hoursCount('0');
    }
    final hours = (minutes * 10 / 60).round() / 10;
    final count = hours == hours.roundToDouble()
        ? hours.round().toString()
        : hours.toStringAsFixed(1);
    return context.l10n.hoursCount(count);
  }

  static String _formatInnerPeacePercent(double value) {
    if (value == value.roundToDouble()) {
      return '${value.round()}%';
    }
    return '${value.toStringAsFixed(1)}%';
  }

  Widget _buildCard({
    required bool isDark,
    required String iconImage,
    required String title,
    required String subTitle,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconImage,
            height: 32,
            width: 32,
            color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
          ),
          SizedBox(height: AppSpacing.lg),
          AppText(
            title,
            style: (context) => AppTextStyles.appBarTitle(context),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            subTitle.replaceFirst(' ', '\n'),
            style: (context) =>
                AppTextStyles.bodyTextSmall(context).copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}
