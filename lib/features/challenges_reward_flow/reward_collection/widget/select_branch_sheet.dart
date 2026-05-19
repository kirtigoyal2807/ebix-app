import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import '../../../../widgets/app_text.dart';
import '../cubit/reward_cubit.dart';
import '../cubit/reward_state.dart';

class SelectBranchSheet extends StatelessWidget {
  const SelectBranchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<RewardCubit, RewardState>(
      builder: (context, state) {
        final maxListHeight = MediaQuery.sizeOf(context).height * 0.62;
        final onSurface = Theme.of(context).colorScheme.onSurface;

        return Material(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                    end: AppSpacing.base,
                    top: AppSpacing.lg,
                    bottom: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          context.l10n.select_branch,
                          style: AppTextStyles.bottomSheetTitle,
                          textAlign: isRTL ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.close, color: onSurface),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxListHeight),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: state.branchList.length,
                    separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _BranchOption(
                        title: state.branchList[index].id == 0
                            ? context.l10n.rewards_all_locations_title
                            : state.branchList[index].title,
                        rewardsCount: state.branchList[index].rewardsCount,
                        selected: state.selectedBranch == index,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<RewardCubit>().selectBranchAtIndex(
                            index,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BranchOption extends StatelessWidget {
  final String title;
  final int rewardsCount;
  final bool selected;
  final VoidCallback onTap;

  const _BranchOption({
    required this.title,
    required this.rewardsCount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lmd,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected
                ? (isDark ? AppColors.languageIconDark : AppColors.languageIcon)
                : (isDark ? AppColors.greyText : AppColors.buttonBorder),
            width: 1,
          ),
          color:
              // selected
              //     ? (isDark
              //           ? AppColors.primaryDarkButton
              //           : AppColors.selectedLanguageBg)
              //     :
              isDark ? AppColors.homeBackground : AppColors.whiteColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    maxLines: 3,
                    style: (context) => AppTextStyles.experienceButton(
                      context,
                    ).copyWith(fontSize: 14, height: 1.25),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    context.l10n.rewards_at_branch_subtitle(rewardsCount),
                    maxLines: 1,
                    style: (context) {
                      final base = AppTextStyles.bodyText(
                        context,
                      ).copyWith(fontSize: 12, height: 1.35);
                      return base.copyWith(
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.greyText,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: selected
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/svg/ic_checkbox_white.svg',
                          width: 10,
                          height: 10,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    )
                  : const SizedBox(width: 20, height: 20),
            ),
          ],
        ),
      ),
    );
  }
}
