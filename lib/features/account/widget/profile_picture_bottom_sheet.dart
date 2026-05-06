import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

enum ProfilePictureAction { camera, gallery, remove }

class ProfilePictureBottomSheet extends StatelessWidget {
  const ProfilePictureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRTL ? AppSpacing.base : AppSpacing.lg,
                      right: isRTL ? AppSpacing.lg : AppSpacing.base,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            context.l10n.changeProfilePicture,
                            style: AppTextStyles.bottomSheetTitle,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDark
                                ? AppColors.lightGrey
                                : AppColors.arrowIcon,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfilePictureOption(
                    title: context.l10n.takePicture,
                    onTap: () =>
                        Navigator.of(context).pop(ProfilePictureAction.camera),
                  ),
                  _ProfilePictureOption(
                    title: context.l10n.accessFromGallery,
                    onTap: () =>
                        Navigator.of(context).pop(ProfilePictureAction.gallery),
                  ),
                  _ProfilePictureOption(
                    title: context.l10n.removeProfilePicture,
                    onTap: () =>
                        Navigator.of(context).pop(ProfilePictureAction.remove),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePictureOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ProfilePictureOption({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: AppText(
          title,
          style: AppTextStyles.experienceButton,
        ),
      ),
    );
  }
}
