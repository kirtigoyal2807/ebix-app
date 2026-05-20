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
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      scrolledUnderElevation: 0,
      // Only show back when [onBack] / [leading] is set — never Material's implied back.
      automaticallyImplyLeading: false,
      leading: leading ??
          (onBack != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  onPressed: onBack,
                )
              : null),
      title: title == null
          ? null
          : AppText(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (context) =>
                  AppTextStyles.appBarTitle(context).copyWith(height: 1),
            ),
      centerTitle: true,
      elevation: 0,
      actions: actions ?? [(isMoreMenu ?? true) ? const SizedBox() : const SizedBox()],
      bottom: bottomPreferredSize,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottomPreferredSize?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
