import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../view/personal_view.dart';
import '../view/push_notification_view.dart';
import 'account_info_tile.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.personalInfo,
          style: (context) => AppTextStyles.captionText(context).copyWith(
            fontWeight: FontWeight.w500,
            height: 1.55,
            color: AppColors.lightGrey,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_personal_data.svg"
              : "assets/images/svg/account/ic_personal_data.svg",
          title: context.l10n.personalData,
          subtitle: context.l10n.personalDataSubtitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalView()),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_push_notification.svg"
              : "assets/images/svg/account/ic_push_notification.svg",
          title: context.l10n.pushNotification,
          subtitle: context.l10n.manageAlertsReminders,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PushNotificationView()),
            );
          },
        ),
      ],
    );
  }
}
