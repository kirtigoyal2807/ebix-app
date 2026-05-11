import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/widgets/app_text.dart';

class GiftToggleCard extends StatelessWidget {
  final bool isGift;
  final ValueChanged<bool> onToggle;

  const GiftToggleCard({
    super.key,
    required this.isGift,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.trainerBlackBackgroundColor
            : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Gift Icon
          SvgPicture.asset(
            'assets/images/svg/ic_gift.svg',
            height: screenHeight * 0.04,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  AppLocalizations.of(context).buyAsGift ?? 'Buy as Gift',
                  style: AppTextStyles.textFieldHeading,
                ),
                const SizedBox(height: 4),
                AppText(
                  AppLocalizations.of(context).perfectForFriends ??
                      'Perfect for friends & family',
                  style: (context) => AppTextStyles.bodyTextSmall(
                    context,
                  ).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8, // 👈 reduce overall size (try 0.7–0.9)
            child: CupertinoSwitch(
              value: isGift,
              onChanged: onToggle,
              activeTrackColor: isDark
                  ? AppColors.switchInactiveDark
                  : AppColors.primary,
              inactiveTrackColor: isDark
                  ? AppColors.switchInactiveDark
                  : AppColors.buttonBorder,
              thumbColor: isDark ? AppColors.primary : AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
