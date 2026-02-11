import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import '../../../widgets/app_text.dart';

class AccountInfoTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  const AccountInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: (context) => AppTextStyles.experienceButton(
                    context,
                  ).copyWith(height: 1),
                ),
                SizedBox(height: AppSpacing.base),
                AppText(
                  subtitle,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(height: 1, color: AppColors.lightGrey),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: isDark ? AppColors.lightGrey : AppColors.arrowIcon,
          ),
        ],
      ),
    );
  }
}
