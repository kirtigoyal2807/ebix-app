import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/home/cubit/home_cubit.dart';
import 'package:pilates_app/widgets/app_text.dart';

class BookingSubscriptionCard extends StatelessWidget {
  const BookingSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeMembershipPlanName =
        context.select((HomeCubit cubit) => cubit.state.data?.membership?.planName) ??
            '';
    final authPlanName = context.select(
          (AuthCubit cubit) => cubit.state.user?.membershipPlanName,
        ) ??
        '';
    final storedPlanName =
        context.read<AuthCubit>().tokenStorage.readMembershipPlanName() ?? '';
    final resolvedPlanName = homeMembershipPlanName.trim().isNotEmpty
        ? homeMembershipPlanName.trim()
        : authPlanName.trim().isNotEmpty
            ? authPlanName.trim()
            : storedPlanName.trim();
    if (resolvedPlanName.isEmpty) {
      return const SizedBox.shrink();
    }
    final planLabel = '${context.l10n.yourPlan}: $resolvedPlanName';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFF3D281A),
            Color(0xFF9A7E6D),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.splashBackgroundDark,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/svg/ic_king.svg',
            width: size.width * 0.05,
            height: size.height * 0.05,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppText(
              planLabel,
              style: (context) => AppTextStyles.helpAndSupportItemLabel(context).copyWith(
                fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                color: isDark ?AppColors.lightText:AppColors.lightText,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
