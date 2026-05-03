import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        final user = state.user;
        final userName = user?.name?.trim();
        final displayName = (userName != null && userName.isNotEmpty)
            ? userName
            : context.l10n.name;
        final email = user?.email?.trim();
        final displayEmail =
            (email != null && email.isNotEmpty) ? email : context.l10n.email;
        final avatar = user?.avatar?.trim();
        final avatarProvider =
            (avatar != null && avatar.isNotEmpty)
            ? NetworkImage(avatar)
            : const AssetImage("assets/images/demo images/Trainer Avatar.png")
                  as ImageProvider;

        return Container(
          height: 192,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.subscriptionCardGradient1,
                AppColors.subscriptionCardGradient2,
              ],
              stops: [0.15, 1.0],
            ),
          ),
          child: Stack(
            children: [
              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lmd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: avatarProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// BASIC BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                            horizontal: AppSpacing.base,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.seekBarLight,
                            borderRadius: BorderRadius.circular(AppRadius.base),
                          ),
                          child: AppText(
                            context.l10n.basic,
                            style: (context) =>
                                AppTextStyles.body(context).copyWith(
                                  fontSize: 12,
                                  height: 1,
                                  color: AppColors.languageIcon,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppText(
                      displayName,
                      style: (context) => AppTextStyles.gelasioMedium(
                        context,
                      ).copyWith(color: Colors.white, height: 1),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      displayEmail,
                      style: (context) => AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: Colors.white, height: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
