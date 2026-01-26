import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart' show AppRadius;
import 'package:pilates_app/config/theme/app_text_styles.dart' show AppTextStyles;

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool expanded;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: AppTextStyles.button(context)),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
