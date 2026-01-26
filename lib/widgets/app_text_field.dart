import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    _obscure = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => _obscure = !_obscure),
        )
            : null,
      ),
    );
  }
}
