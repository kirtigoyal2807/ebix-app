import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle Function(BuildContext) style;
  final TextAlign? textAlign;

  const AppText(
      this.text, {
        super.key,
        required this.style,
        this.textAlign,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style(context),
      textAlign: textAlign,
    );
  }
}
