import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

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
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _suppressBackwardFocus = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emitOtp() {
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);

    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  void _onChanged(String value, int index) {
    if (!_suppressBackwardFocus && value.isEmpty && index > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusNodes[index - 1].requestFocus();
      });
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    _emitOtp();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event, int index) {
    final isDown = event is KeyDownEvent || event is KeyRepeatEvent;
    if (!isDown) return KeyEventResult.ignored;

    final isBack =
        event.logicalKey == LogicalKeyboardKey.backspace ||
        event.logicalKey == LogicalKeyboardKey.delete;
    if (!isBack) return KeyEventResult.ignored;

    if (_controllers[index].text.isNotEmpty) {
      return KeyEventResult.ignored;
    }

    if (index <= 0) return KeyEventResult.ignored;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _suppressBackwardFocus = true;
      _controllers[index - 1].clear();
      _suppressBackwardFocus = false;
      _focusNodes[index - 1].requestFocus();
    });

    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        final focusNode = _focusNodes[index];
        return Container(
          margin: EdgeInsets.only(
            right: index == widget.length - 1 ? 0 : AppSpacing.sm,
          ),
          width: 48,
          height: 48,
          child: Focus(
            onKeyEvent: (node, event) => _handleKey(node, event, index),
            child: TextField(
              controller: _controllers[index],
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: theme.textTheme.titleMedium,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
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
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        );
      }),
    );
  }
}
