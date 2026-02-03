import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle Function(BuildContext) style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;


  const AppText(
      this.text, {
        super.key,
        required this.style,
        this.textAlign,
        this.maxLines,
        this.overflow
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style(context),
      textAlign: textAlign,
      maxLines: maxLines ?? 2,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
