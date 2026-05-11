import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import 'app_text.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final bool readOnly;
  final void Function()? onTap;
  final TextStyle? style;

  /// Shown under the field when [maxLength] is set (e.g. `12/100`).
  final bool showCharacterCounter;

  /// When set, the parent owns disposal. Otherwise an internal controller is used.
  final TextEditingController? controller;

  /// Shows a clear icon when the field has text (non-[obscure] fields only).
  final bool showClearButton;

  /// Passed to the underlying [TextField.scrollPadding] (e.g. room above keyboard).
  final EdgeInsets scrollPadding;

  final List<TextInputFormatter>? inputFormatters;

  /// When null, an internal node is created and disposed by this widget.
  final FocusNode? focusNode;

  final TextInputAction? textInputAction;

  final void Function(String)? onFieldSubmitted;

  const AppTextField({
    super.key,
    this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.initialValue,
    this.maxLines,
    this.maxLength,
    this.showCharacterCounter = true,
    this.controller,
    this.showClearButton = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.style,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  late final TextEditingController _ownedController;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _ownedController = TextEditingController(text: widget.initialValue ?? '');
    _controller = widget.controller ?? _ownedController;
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _ownedController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue != _controller.text) {
        _controller.text = widget.initialValue ?? "";
      }
    }
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
        if (widget.label != null)
          AppText(widget.label ?? "", style: AppTextStyles.textFieldHeading),
        if (widget.label != null) SizedBox(height: AppSpacing.sm),

        /// TEXT FIELD
        Stack(
          children: [
            TextFormField(
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              controller: _controller,
              focusNode: _focusNode,
              scrollPadding: widget.scrollPadding,
              maxLength: widget.maxLength,
              buildCounter:
                  (
                    context, {
                    required int currentLength,
                    required bool isFocused,
                    int? maxLength,
                  }) => null,

              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              textInputAction: widget.textInputAction,
              // initialValue: widget.initialValue,
              obscureText: _obscure,
              keyboardType: widget.keyboardType,
              textDirection: widget.keyboardType == TextInputType.phone
                  ? TextDirection.ltr
                  : null,
              style: widget.style ?? AppTextStyles.textField(context),
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
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
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          );
                        },
                      )
                    : widget.showClearButton
                    ? AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          if (_controller.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.lightGrey,
                            ),
                            onPressed: () {
                              _controller.clear();
                              widget.onChanged?.call('');
                            },
                          );
                        },
                      )
                    : null,
              ),
            ),
            Visibility(
              visible: widget.maxLength != null && widget.showCharacterCounter,
              child: Positioned(
                left: 12,
                bottom: 8,
                child: AppText(
                  "${_controller.text.length}/${widget.maxLength}",
                  style: (style) => AppTextStyles.captionText(context).copyWith(
                    color: isDark ? AppColors.lightGrey : AppColors.greyText,
                  ),
                ),
              ),
            ),
          ],
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
