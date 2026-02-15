import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../../account/widget/account_info_tile.dart';

class DiscoverInfo extends StatelessWidget {
  const DiscoverInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
        context.l10n.discover,
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
          title: context.l10n.browseTrainers,
          subtitle:  context.l10n.meetOurTrainers
        ),
      ],
    );
  }
}
