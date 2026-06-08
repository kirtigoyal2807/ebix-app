import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
                  SizedBox(height: AppSpacing.base),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        _ProfilePictureOption(
                          iconAsset: isDark
                              ? 'assets/images/svg/account/cameraDark.svg'
                              : 'assets/images/svg/account/cameraLight.svg',
                          title: context.l10n.takePicture,
                          onTap: () => Navigator.of(context).pop(
                            ProfilePictureAction.camera,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _ProfilePictureOption(
                          iconAsset: isDark
                              ? 'assets/images/svg/account/galleryDark.svg'
                              : 'assets/images/svg/account/galleryLight.svg',
                          title: context.l10n.accessFromGallery,
                          onTap: () => Navigator.of(context).pop(
                            ProfilePictureAction.gallery,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _ProfilePictureOption(
                          iconAsset: isDark
                              ? 'assets/images/svg/account/deleteDark.svg'
                              : 'assets/images/svg/account/deleteLight.svg',
                          title: context.l10n.removeProfilePicture,
                          onTap: () => Navigator.of(context).pop(
                            ProfilePictureAction.remove,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.bottomActionPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePictureOption extends StatefulWidget {
  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  const _ProfilePictureOption({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  @override
  State<_ProfilePictureOption> createState() => _ProfilePictureOptionState();
}

class _ProfilePictureOptionState extends State<_ProfilePictureOption> {
  String selectedTitle = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool selected = selectedTitle == widget.title;
    return InkWell(
      onTap: () {
        selectedTitle = widget.title;
        setState(() {});
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected
                ? (isDark ? AppColors.languageIconDark : AppColors.languageIcon)
                : Colors.transparent,
            width: 1.5,
          ),
          color: selected
              ? (isDark
                    ? AppColors.primaryDarkButton
                    : AppColors.selectedLanguageBg)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.iconAsset,
              width: 24,
              height: 24,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppText(
                widget.title,
                style: AppTextStyles.experienceButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
