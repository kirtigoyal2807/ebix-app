import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../../core/localization/arb/app_localizations.dart';
import '../cubit/gift_subscription_cubit.dart';
import '../cubit/gift_subscription_state.dart';
import 'delivery_option_tile.dart';

class ReceiptDetails extends StatelessWidget {
  const ReceiptDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => GiftSubscriptionCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.recipientDetails,
            style: (context) => AppTextStyles.heading1(
              context,
            ).copyWith(fontSize: 24, height: 1.2),
          ),

          SizedBox(height: AppSpacing.md),

          AppTextField(label: l10n.recipientNameHint, hint: l10n.recipientNameHint),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.recipientEmail,
            hint: l10n.recipientEmailHint,
          ),
          SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.recipientPhoneOptional, hint: "XXXXXXXXXXX"),
          SizedBox(height: AppSpacing.md),

          AppText(l10n.deliveryOptions, style: AppTextStyles.textFieldHeading),
          SizedBox(height: AppSpacing.base),

          BlocBuilder<GiftSubscriptionCubit, GiftSubscriptionState>(
            builder: (context, state) {
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSpacing.sm),
                itemCount: state.deliveryOptions.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context
                          .read<GiftSubscriptionCubit>()
                          .changeDeliveryOption(state.deliveryOptions[index]);
                    },
                    child: DeliveryOptionTile(
                      label: getLabel(state.deliveryOptions[index], l10n),
                      isSelected:
                          state.selectedDeliveryOption ==
                          state.deliveryOptions[index],
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: AppSpacing.md),

          AppTextField(
            label: l10n.personalMessageOptional,
            hint: l10n.personalMessageHint,
            maxLines: 4,
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            l10n.charactersCount,
            style: (context) => AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.lightGrey, height: 1.5),
          ),
        ],
      ),
    );
  }

  String getLabel(DeliveryOption deliveryOption, l10n) {
    switch (deliveryOption) {
      case DeliveryOption.instantDelivery:
        return l10n.instantDelivery;

      case DeliveryOption.scheduledDelivery:
        return l10n.scheduledDelivery1;
    }
  }
}
