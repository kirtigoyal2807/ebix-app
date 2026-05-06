import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'app_app_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final AppAppBar? appBar;

  const AppScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: SafeArea(child: body),
    );
  }
}
