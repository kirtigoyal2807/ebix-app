import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../../config/theme/app_spacing.dart';

class BranchSelector extends StatelessWidget {
  final List<String> branches;
  final String selectedBranchId;
  final ValueChanged<String> onSelect;

  const BranchSelector({
    super.key,
    required this.branches,
    required this.selectedBranchId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left:AppSpacing.lg),
        child: Row(
          children: branches.map((branch) {
            final isSelected = branch == selectedBranchId;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => onSelect(branch),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isDark
                        ? AppColors.switchInactiveDark
                        : AppColors.greyContainerBg,
                    // Dark brown for selected
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: AppText(
                    branch, // You might want to map branchId to display name
                    style: (style) =>
                        AppTextStyles.bodyTextSmall(context).copyWith(
                          color: isSelected
                              ? AppColors.whiteColor
                              : (isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
