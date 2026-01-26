import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_scaffold.dart' show AppScaffold;
import 'package:pilates_app/widgets/app_text.dart';

import 'app_logo.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: const AppLogo(size: 140),
      ),
    );
  }
}
