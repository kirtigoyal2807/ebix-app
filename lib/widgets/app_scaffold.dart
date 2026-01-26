import 'package:flutter/material.dart';
import 'app_app_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final AppAppBar? appBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(child: body),
    );
  }
}
