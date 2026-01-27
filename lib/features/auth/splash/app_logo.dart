import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SvgPicture.asset(
      isDark
          ? 'assets/images/svg/ic_splash_dark_code.svg'
          : 'assets/images/svg/ic_splash_light_code.svg',
      width: size,
      height: size,
    );
  }
}
