import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

/// Search field bound to [BookingCubit.searchQuery] so text survives list reloads
/// and stays in sync when the query is updated elsewhere.
class BookingSearchBar extends StatefulWidget {
  final String? hintText;

  const BookingSearchBar({super.key, this.hintText});

  @override
  State<BookingSearchBar> createState() => _BookingSearchBarState();
}

class _BookingSearchBarState extends State<BookingSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<BookingCubit>().state.searchQuery,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery,
      listener: (context, state) {
        if (_controller.text != state.searchQuery) {
          _controller.value = TextEditingValue(
            text: state.searchQuery,
            selection: TextSelection.collapsed(
              offset: state.searchQuery.length,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: TextField(
          controller: _controller,
          onChanged: (query) =>
              context.read<BookingCubit>().updateSearchQuery(query),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.textField(context),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? AppColors.darkGreyText : AppColors.darkGreyText,
            ),
            filled: false,
            hintText: widget.hintText ?? context.l10n.searchClassesHint,
            hintStyle: AppTextStyles.textField(
              context,
            ).copyWith(color: AppColors.lightGrey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: theme.dividerColor),
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
      ),
    );
  }
}
