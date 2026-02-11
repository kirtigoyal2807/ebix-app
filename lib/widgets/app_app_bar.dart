import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool? isMoreMenu;
  final PreferredSize? bottomPreferredSize;
  final Widget? leading;


  const AppAppBar({
    super.key,
    this.title,
    this.onBack,
    this.actions,
    this.isMoreMenu = true,
    this.bottomPreferredSize,
    this.leading,

  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      surfaceTintColor: Colors.transparent,
      // IMPORTANT (Material 3)
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      scrolledUnderElevation: 0,
      // IMPORTANT
      leading:
          leading ??
          (onBack != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  onPressed: onBack,
                )
              : null),

      title: title != null
          ? AppText(title!, style: AppTextStyles.appBarTitle)
          : null,
      centerTitle: true,
      elevation: 0,
      actions: actions??[
        (isMoreMenu ?? true)
            ? IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {})
            : SizedBox(),

      ],
      bottom: bottomPreferredSize,

      // backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize =>
      bottomPreferredSize?.preferredSize ??
      const Size.fromHeight(kToolbarHeight);
}
