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

Future<void> showLanguageBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    barrierColor: AppColors.bottomSheetShadow,
    backgroundColor:
        isDark ? AppColors.homeBackground : AppColors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const LanguageBottomSheet(),
  );
}

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = context.read<AuthCubit>().state.locale;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor =
        isDark ? AppColors.homeBackground : AppColors.whiteColor;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Material(
          color: sheetColor,
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
                          left: isRTL ? AppSpacing.base : AppSpacing.lg,
                          right: isRTL ? AppSpacing.lg : AppSpacing.base,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText(
                                context.l10n.selectLanguage,
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

                      SizedBox(height: AppSpacing.xl + 2),

                      // Language options — shared horizontal inset so flag + label align
                      // for selected and non-selected rows.
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: [
                            _LanguageOption(
                              flag: '🇺🇸',
                              title: 'English (US)',
                              locale: const Locale('en'),
                              selected: _selectedLocale.languageCode == 'en',
                              onTap: () {
                                setState(() {
                                  _selectedLocale = const Locale('en');
                                });
                              },
                            ),
                            SizedBox(height: AppSpacing.md),
                            _LanguageOption(
                              flag: '🇸🇦',
                              title: 'العربية',
                              locale: const Locale('ar'),
                              selected: _selectedLocale.languageCode == 'ar',
                              onTap: () {
                                setState(() {
                                  _selectedLocale = const Locale('ar');
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Confirm button with white background extending to bottom
                Container(
                  width: double.infinity,
                  color: sheetColor,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.bottomActionPadding,
                  ),
                  child: AppButton(
                    label: context.l10n.confirm,
                    onPressed: () {
                      context.read<AuthCubit>().changeLanguage(_selectedLocale);
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

class _LanguageOption extends StatelessWidget {
  /// Inner padding must match for [selected] and unselected so flag + title stay aligned.
  static final EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md + 1,
    vertical: AppSpacing.md + 1,
  );

  final String flag;
  final String title;
  final Locale locale;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.title,
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: _contentPadding,
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
          children: [
            Text(flag, style: TextStyle(fontSize: 24)),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppText(title, style: AppTextStyles.experienceButton),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: (isDark
                      ? AppColors.languageIconDark
                      : AppColors.languageIcon),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/svg/ic_checkbox_white.svg",
                    width: 10,
                    height: 10,
                    fit: BoxFit.contain,
                    // colorFilter: ColorFilter.mode(
                    //   selected ? theme.colorScheme.primary : theme.hintColor,
                    //   BlendMode.srcIn,
                    // ),
                    alignment: Alignment.center,
                  ),
                ),
                // child: const Icon(Icons.check, color: Colors.white, size: 14),
              )
            else
              const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
