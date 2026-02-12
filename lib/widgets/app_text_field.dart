import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import 'app_text.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.initialValue,
    this.maxLines
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _obscure = widget.obscure;
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        AppText(widget.label, style: AppTextStyles.textFieldHeading),

        const SizedBox(height: AppSpacing.sm),

        /// TEXT FIELD
        TextFormField(
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          initialValue: widget.initialValue,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: AppTextStyles.textField(context),
          maxLines:widget.maxLines ,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.textField(
              context,
            ).copyWith(color: AppColors.lightGrey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            /// BORDER
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: hasError
                    ? isDark
                          ? AppColors.redDark
                          : AppColors.redLight
                    : theme.dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: hasError ? Colors.red : theme.colorScheme.primary,
                width: 1.5,
              ),
            ),

            /// PASSWORD TOGGLE
            // suffixIcon: widget.obscure
            //     ? IconButton(
            //   icon: Icon(
            //     _obscure
            //         ? Icons.visibility_off
            //         : Icons.visibility,
            //     size: 20,
            //     color:  AppColors.lightGrey,
            //   ),
            //   onPressed: () =>
            //       setState(() => _obscure = !_obscure),
            // )
            //     : null,
            suffixIcon: widget.obscure
                ? AnimatedBuilder(
                    animation: _focusNode,
                    builder: (context, _) {
                      final isFocused = _focusNode.hasFocus;

                      return IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                          color: hasError
                              ? (isDark
                                    ? AppColors.redDark
                                    : AppColors.redLight)
                              : isFocused
                              ? (isDark
                                    ? Colors.white
                                    : AppColors.homeBackground)
                              : AppColors.lightGrey,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      );
                    },
                  )
                : null,
          ),
        ),

        /// ERROR MESSAGE
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? AppColors.redDark : AppColors.redLight,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.redDark : AppColors.redLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
