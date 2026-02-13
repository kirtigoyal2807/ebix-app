import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class DeliveryOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;

  const DeliveryOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? (isSelected
              ? AppColors.darkGreyBorder
              : AppColors.greyText)
              : (isSelected
              ? AppColors.primary
              : AppColors.buttonBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            style: (context) => AppTextStyles.textFieldHeading(context),
          ),

          isSelected
              ? SvgPicture.asset("assets/images/svg/ic_radio_check.svg")
              : Icon(
                  Icons.radio_button_off,
                  color: AppColors.buttonBorder,
                  size: 20,
                ),
        ],
      ),
    );
  }
}
