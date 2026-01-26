import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;

  const AppAppBar({super.key, this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      )
          : null,
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
