import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_text.dart';
import '../../data/models/progress_session_history_item.dart';

class SessionHistoryCard extends StatelessWidget {
  const SessionHistoryCard({super.key, this.item});

  final ProgressSessionHistoryItem? item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final classTitle = item?.className ?? context.l10n.session_card_class_name;
    final instructor =
        item?.trainerName != null && item!.trainerName!.isNotEmpty
        ? 'with ${item!.trainerName}'
        : context.l10n.session_card_instructor;
    final statusLabel = item?.status.isNotEmpty == true
        ? item!.status
        : context.l10n.session_card_status_completed;
    final dateLine = item != null
        ? DateFormat.yMMMd(locale).format(item!.startTime.toLocal())
        : context.l10n.session_card_today;
    final durationLine = item != null
        ? '${item!.durationMinutes} Min'
        : context.l10n.session_card_duration;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    classTitle,
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                    ).copyWith(height: 1.4),
                  ),
                  AppText(
                    instructor,
                    style: (context) =>
                        AppTextStyles.caption(context).copyWith(height: 1.4),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.36)
                      : AppColors.featuredTagBackgroundColor,
                ),
                child: AppText(
                  statusLabel,
                  style: (context) =>
                      AppTextStyles.splashVersion(context).copyWith(
                        color: isDark
                            ? AppColors.successBorderDark
                            : AppColors.successColor,
                        height: 1.8,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.languageIcon,
              ),
              SizedBox(width: AppSpacing.xs),
              AppText(
                dateLine,
                style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                  context,
                ).copyWith(height: 1.2),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.schedule, size: 16, color: AppColors.languageIcon),
              SizedBox(width: AppSpacing.xs),
              AppText(
                durationLine,
                style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                  context,
                ).copyWith(height: 1.2),
              ),
              const Spacer(),
              if (item == null)
                AppText(
                  context.l10n.session_card_points,
                  style: (context) =>
                      AppTextStyles.body(context).copyWith(height: 1.2),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
