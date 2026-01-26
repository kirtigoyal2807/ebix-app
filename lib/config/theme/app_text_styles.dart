import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onBackground,
      );

  static TextStyle body(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onBackground,
      );

  static TextStyle caption(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).hintColor,
      );

  static TextStyle button(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
