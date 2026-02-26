import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/review_screen_details_view.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/dotted_underline.dart';
import '../cubit/subscription_cubit.dart';

class ReviewScreenView extends StatelessWidget {
  const ReviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        // horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          ReviewScreenDetailsView(),

          // Continue Button
          BlocBuilder<SubscriptionCubit, SubscriptionState>(
            buildWhen: (previous, current) =>
                previous.isTermsAccepted != current.isTermsAccepted,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(

                  horizontal: AppSpacing.lg,
                ),
                child: AppButton(
                  label: l10n.continueToPayment,
                  onPressed: state.isTermsAccepted
                      ? () {
                          // Navigate to payment or finish flow
                          cubit.nextStep(); // Or handle payment logic
                        }
                      : null, // Disable if not accepted
                  buttonColor: isDark ?AppColors.primary:AppColors.primaryBrown,
                  expanded: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
