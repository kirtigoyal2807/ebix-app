import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class PlanDetailsModal extends StatelessWidget {
  final Map<String, dynamic> plan;
  final String? appLabel;

  const PlanDetailsModal({super.key, required this.plan,this.appLabel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (plan['badge'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: plan['isPopular'] == true
                        ? (isDark
                              ? const Color(0x3BFDC700)
                              : AppColors.goldStarColor)
                        : (isDark
                              ? const Color(0x3BFDC700)
                              : AppColors.goldStarColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    plan['badge'],
                    style: (context) => AppTextStyles.body(context).copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: (isDark
                          ? AppColors.upgradeDarkLockBackgroundColor
                          : AppColors.darkText),
                    ),
                  ),
                )
              else
                const SizedBox(),
              Container(
                height: 28,
                width: 32,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 22,
                    color: isDark
                        ? AppColors.lightGrey
                        : AppColors.darkGreyText,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          // SizedBox(height: AppSpacing.xs),
          AppText(
            plan['title'],
            style: (context) => AppTextStyles.headline(context).copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              AppText(
                '${plan['price']}',
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.languageTextDark
                      : AppColors.languageIcon, // Light brown/gold
                ),
              ),
              SvgPicture.asset(
                "assets/images/svg/ic_Saudi_Riyal_Symbol.svg",
                height: 24,
                width: 24,
              ),
              AppText(
                ' / Month',
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.languageTextDark
                      : AppColors.languageIcon, // Light brown/gold
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (plan['features'] != null)
            Container(
              // margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
              // height: (20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.lightBlackColor
                    : AppColors.seekBarLight, // Very light orange/brown
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: (plan['features'] as List<String>).map((feature) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          size: 12,
                          color: isDark
                              ? AppColors.seekBarLight
                              : AppColors.languageIcon,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: AppText(
                            feature,
                            style:(style)=> AppTextStyles.bodyTextSmall(context)
                                .copyWith(
                                  color: isDark
                                      ? AppColors.lightText
                                      : AppColors.greyText,
                                  fontSize: 12,
                              height: 1.2
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 32),
          AppButton(
            label: appLabel??'Subscribe Now',
            onPressed: () {},
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
