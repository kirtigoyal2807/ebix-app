import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';

class CurrentBookingView extends StatelessWidget {
  const CurrentBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isDark
              ? SvgPicture.asset("assets/images/svg/ic_dark_no_class.svg")
              : SvgPicture.asset("assets/images/svg/ic_no_class.svg"),
          SizedBox(height: AppSpacing.lmd),
          AppText(
            context.l10n.noClassesToday,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.noClassesDescription,
            style: (context) => AppTextStyles.bodyText(
              context,
            ).copyWith(fontSize: 16, height: 1.55),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
