import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';

class ConfirmationSheet extends StatelessWidget {
  final String confirmationText;
  final String buttonText;

  /// After the sheet is popped, runs when the user taps [buttonText] (destructive confirm).
  final Future<void> Function()? onDestructive;

  const ConfirmationSheet({
    super.key,
    required this.confirmationText,
    required this.buttonText,
    this.onDestructive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            confirmationText,
            textAlign: TextAlign.center,
            style: (context) => AppTextStyles.bottomSheetTitle(context),
          ),
          SizedBox(height: AppSpacing.xl),

          AppButton(
            label: context.l10n.keepIt,
            onPressed: () => Navigator.pop(context),
            variant: AppButtonVariant.primary,
          ),

          SizedBox(height: AppSpacing.sm),

          // Cancel
          Center(
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final run = onDestructive;
                if (run != null) await run();
              },

              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (AppSpacing.buttonHeight - 30) / 2,
                ),
                child: AppText(
                  buttonText,
                  style: (context) => AppTextStyles.button(
                    context,
                  ).copyWith(color: AppColors.lightGrey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
