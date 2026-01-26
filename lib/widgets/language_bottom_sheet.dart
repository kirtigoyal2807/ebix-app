import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';

import '../../../core/localization/localization_extension.dart';
import '../features/auth/cubit/auth_cubit.dart';
import 'app_text.dart';


class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Material(
            color: Colors.white, // ✅ WHITE BACKGROUND
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(
                        bottom: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius:
                        BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),

                  // Title
                  AppText(
                    context.l10n.changeLanguage,
                    style: AppTextStyles.headline,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  _LanguageOption(
                    title: 'English',
                    locale: const Locale('en'),
                    selected: state.locale.languageCode == 'en',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _LanguageOption(
                    title: 'العربية',
                    locale: const Locale('ar'),
                    selected: state.locale.languageCode == 'ar',
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _LanguageOption extends StatelessWidget {
  final String title;
  final Locale locale;
  final bool selected;

  const _LanguageOption({
    required this.title,
    required this.locale,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.read<AuthCubit>().changeLanguage(locale);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: selected ? 1.5 : 1,
          ),
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                title,
                style: AppTextStyles.body,
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
