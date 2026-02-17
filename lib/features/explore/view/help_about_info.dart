import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/explore/view/privacy_policy_view.dart';
import 'package:pilates_app/features/explore/view/term_condition_view.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../../account/widget/account_info_tile.dart';
import 'help_support_view.dart';

class HelpAboutInfo extends StatelessWidget {
  const HelpAboutInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(

          context.l10n.helpAbout,
          style: (context) => AppTextStyles.captionText(context).copyWith(
            fontWeight: FontWeight.w500,
            height: 1.55,
            color: AppColors.lightGrey,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap:  () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpSupportView()),
            );
          },
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_help_support.svg"
              : "assets/images/svg/explore/ic_help_support.svg",
          title: context.l10n.helpSupport,
          subtitle: context.l10n.helpSupportSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermConditionView()),
            );
          },
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_term_condition.svg"
              : "assets/images/svg/explore/ic_term_condition.svg",
          title: context.l10n.termsConditions,
          subtitle: context.l10n.termsConditionsSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyView()),
            );
          },
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_privacy_policy.svg"
              : "assets/images/svg/explore/ic_privacy_policy.svg",
          title: context.l10n.privacyPolicy,
          subtitle: context.l10n.privacyPolicySubtitle,
        ),
      ],
    );
  }
}
