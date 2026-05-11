import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/svg/ic_book_dark.svg'
                  : 'assets/images/svg/ic_book_light.svg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppText(
            context.l10n.branchDowntown,
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            context.l10n.branchUptown,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
