import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

/// Digits only, capped at [maxLen]. Collapses caret to end for predictable OTP typing.
class _OtpDigitsFormatter extends TextInputFormatter {
  _OtpDigitsFormatter(this.maxLen);

  final int maxLen;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digitsOnly.length <= maxLen
        ? digitsOnly
        : digitsOnly.substring(0, maxLen);
    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

class OtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final void Function(String otp)? onCompleted;

  const OtpField({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _lastEmitted = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _handleControllerChanged() {
    final otp = _controller.text;
    if (otp != _lastEmitted) {
      _lastEmitted = otp;
      widget.onChanged?.call(otp);
      if (otp.length == widget.length) {
        widget.onCompleted?.call(otp);
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Index of the box that shows keyboard focus / next insertion point.
  int get _highlightIndex {
    if (!_focusNode.hasFocus) return -1;
    final n = _controller.text.length;
    if (n >= widget.length) return widget.length - 1;
    return n;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = _controller.text;

    final transparentFieldStyle =
        theme.textTheme.titleMedium?.copyWith(color: Colors.transparent) ??
        TextStyle(fontSize: 16, height: 1, color: Colors.transparent);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const maxCell = 48.0;
          const gap = AppSpacing.sm;
          final totalGaps = (widget.length - 1) * gap;
          final available = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : double.infinity;
          final fitted = available.isFinite
              ? (available - totalGaps) / widget.length
              : maxCell;
          final cell = math.max(0.0, math.min(maxCell, fitted));
          final rowInnerWidth =
              widget.length * cell + (widget.length - 1) * gap;

          return Align(
            child: SizedBox(
              width: rowInnerWidth,
              height: cell,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.left,
                      showCursor: false,
                      autofocus: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      smartDashesType: SmartDashesType.disabled,
                      smartQuotesType: SmartQuotesType.disabled,
                      style: transparentFieldStyle,
                      cursorWidth: 0,
                      cursorColor: Colors.transparent,
                      inputFormatters: [
                        _OtpDigitsFormatter(widget.length),
                      ],
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                      ),
                      maxLines: 1,
                      autofillHints: const [AutofillHints.oneTimeCode],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.length, (index) {
                      final hasFocus = _focusNode.hasFocus;
                      final hl = _highlightIndex;
                      final digit =
                          index < text.length ? text[index] : '';
                      final right = index == widget.length - 1 ? 0.0 : gap;

                      return Padding(
                        padding: EdgeInsets.only(right: right),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _focusNode.requestFocus(),
                          child: Container(
                            width: cell,
                            height: cell,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: hasFocus && index == hl
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor,
                                width: hasFocus && index == hl ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              digit,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
