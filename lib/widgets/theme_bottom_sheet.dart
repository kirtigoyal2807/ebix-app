import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';

import '../features/auth/cubit/auth_cubit.dart';
import 'app_text.dart';
import 'app_button.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = context.read<AuthCubit>().state.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Material(
          // color: Colors.white,
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
                      // Header with title and close button
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText(
                                context.l10n.selectTheme,
                                style: AppTextStyles.bottomSheetTitle,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.arrowIcon,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // Language options
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: [
                            _ThemeOption(
                              title: context.l10n.lightTheme,

                              selected: _selectedThemeMode == ThemeMode.light,
                              onTap: () {
                                setState(() {
                                  _selectedThemeMode = ThemeMode.light;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSpacing.sm),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: _ThemeOption(
                          title: context.l10n.darkTheme,

                          selected: _selectedThemeMode == ThemeMode.dark,
                          onTap: () {
                            setState(() {
                              _selectedThemeMode = ThemeMode.dark;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: _ThemeOption(
                          title: context.l10n.systemTheme,

                          selected: _selectedThemeMode == ThemeMode.system,
                          onTap: () {
                            setState(() {
                              _selectedThemeMode = ThemeMode.system;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Confirm button with white background extending to bottom
                Container(
                  width: double.infinity,
                  // color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.md + 2,
                  ),
                  child: AppButton(
                    label: context.l10n.switchTheme,
                    onPressed: () {
                      context.read<AuthCubit>().changeTheme(_selectedThemeMode);
                      Navigator.of(context).pop();
                    },
                    variant: AppButtonVariant.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;

  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,

    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              title,
              style: (context) =>
                  AppTextStyles.experienceButton(context).copyWith(height: 1.6),
            ),
            if (selected)
              SvgPicture.asset(
                // isDark
                //     ? "assets/images/svg/ic_dark_radio_check.svg"
                //     :
                "assets/images/svg/ic_radio_check.svg",
                height: 20,
                width: 20,
              )
            else
              Icon(
                Icons.radio_button_off,
                color: AppColors.buttonBorder,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
