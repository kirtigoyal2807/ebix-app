import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class SignUpHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int step;
  final int totalSteps;

  const SignUpHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, style: AppTextStyles.heading1),
        SizedBox(height: AppSpacing.xs),
        AppText(subtitle, style: AppTextStyles.bodyText, maxLines: 3),
      ],
    );
  }
}
