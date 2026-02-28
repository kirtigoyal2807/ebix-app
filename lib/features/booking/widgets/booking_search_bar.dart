import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import '../cubit/booking_cubit.dart';

class BookingSearchBar extends StatelessWidget {
  final String? hintText;
  const BookingSearchBar({super.key,this.hintText});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: TextField(
        onChanged: (query) => context.read<BookingCubit>().updateSearchQuery(query),
        keyboardType: TextInputType.emailAddress,
        style: AppTextStyles.textField(context),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.darkGreyText : AppColors.darkGreyText,
          ),
          filled: false,
          hintText:hintText?? context.l10n.searchClassesHint,
          hintStyle: AppTextStyles.textField(context).copyWith(color: AppColors.lightGrey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),

          /// BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(
              color: theme.dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
