import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';

import '../features/auth/cubit/auth_cubit.dart';
import 'app_text.dart';
import 'app_button.dart';

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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Material(
          // color: Colors.white,
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
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl + 2),

                      // Language options
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: [
                            _LanguageOption(
                              flag: '🇺🇸',
                              title: 'English',
                              locale: const Locale('en'),
                              selected: _selectedLocale.languageCode == 'en',
                              onTap: () {
                                setState(() {
                                  _selectedLocale = const Locale('en');
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: _LanguageOption(
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
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(selected ? AppSpacing.md + 1 : AppSpacing.base),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primaryDark : Colors.transparent,
            width: 1.5,
          ),
          color: selected ? (isDark ? AppColors.primaryDarkButton:AppColors.selectedLanguageBg) : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppText(
                title,
                style: AppTextStyles.experienceButton,
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              )
            else
              const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
