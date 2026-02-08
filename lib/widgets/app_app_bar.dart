import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool? isMoreMenu;

  const AppAppBar({super.key, this.title, this.onBack, this.actions, this.isMoreMenu = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,size: 20,),
        onPressed: onBack,
        
      )
          : null,

      title: title != null ? AppText(title!, style: AppTextStyles.appBarTitle,) : null,
      centerTitle: true,
      elevation: 0,
      actions: [
        (isMoreMenu ?? true) ? IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ):SizedBox(),
      ],
      // backgroundColor: Colors.white,
      
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
