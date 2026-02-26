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
        return Material(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and close button
                      Padding(
                        padding: EdgeInsets.only(
                          left: isRTL ? AppSpacing.base : AppSpacing.lg,
                          right: isRTL ? AppSpacing.lg : AppSpacing.base,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText(
                               context.l10n.select_branch,
                                style: AppTextStyles.bottomSheetTitle,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xff1C1B1F),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lmd),

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.branchList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.xi,
                            ),
                            child: Column(
                              children: [
                                _BranchOption(
                                  title: state.branchList[index].title,
                                  subTitle: state.branchList[index].subTitle,
                                  selected: state.selectedBranch == index,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<RewardCubit>()
                                        .setSelectedBranch(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
  final String subTitle;
  final bool selected;
  final VoidCallback onTap;

  const _BranchOption({
    required this.title,
    required this.subTitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: (context) => AppTextStyles.experienceButton(
                      context,
                    ).copyWith(fontSize: 14, height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.xs,),
                  AppText(
                    subTitle,
                    style: (context) => AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      (
                      // isDark
                      // ? AppColors.languageIconDark
                      // :
                      AppColors.primary),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/svg/ic_checkbox_white.svg",
                    width: 10,
                    height: 10,
                    fit: BoxFit.contain,

                    // colorFilter: ColorFilter.mode(
                    //   selected ? theme.colorScheme.primary : theme.hintColor,
                    //   BlendMode.srcIn,
                    // ),
                    alignment: Alignment.center,
                  ),
                ),
                // child: const Icon(Icons.check, color: Colors.white, size: 14),
              )
            else
              const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
