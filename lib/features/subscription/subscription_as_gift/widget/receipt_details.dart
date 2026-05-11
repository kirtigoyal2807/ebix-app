import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../../core/localization/arb/app_localizations.dart';
import '../cubit/gift_subscription_cubit.dart';
import '../cubit/gift_subscription_state.dart';
import 'delivery_option_tile.dart';

class ReceiptDetails extends StatelessWidget {
  const ReceiptDetails({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.messageController,
    required this.onCountryCodeChanged,
    this.recipientNameErrorText,
    this.recipientEmailErrorText,
    this.recipientPhoneErrorText,
    this.deliveryDateErrorText,
    this.onRecipientNameChanged,
    this.onRecipientEmailChanged,
    this.onRecipientPhoneChanged,
    this.onDeliverySelectionChanged,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final ValueChanged<String> onCountryCodeChanged;
  final String? recipientNameErrorText;
  final String? recipientEmailErrorText;
  final String? recipientPhoneErrorText;
  final String? deliveryDateErrorText;
  final ValueChanged<String>? onRecipientNameChanged;
  final ValueChanged<String>? onRecipientEmailChanged;
  final ValueChanged<String>? onRecipientPhoneChanged;
  final VoidCallback? onDeliverySelectionChanged;

  static String _formatScheduledDate(BuildContext context, String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    final d = DateTime(parsed.year, parsed.month, parsed.day);
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d);
  }

  Future<void> _onDeliveryTileTap(
    BuildContext context,
    DeliveryOption option,
  ) async {
    final cubit = context.read<GiftSubscriptionCubit>();
    final state = cubit.state;

    if (option == DeliveryOption.instantDelivery) {
      cubit.selectInstantDelivery();
      onDeliverySelectionChanged?.call();
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    FocusManager.instance.primaryFocus?.unfocus();
    var initialDate = today.add(const Duration(days: 7));
    final stored = state.scheduledDeliveryDateIso;
    if (stored != null && stored.isNotEmpty) {
      final parsed = DateTime.tryParse(stored);
      if (parsed != null) {
        var d = DateTime(parsed.year, parsed.month, parsed.day);
        if (d.isBefore(today)) {
          d = today;
        }
        initialDate = d;
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
    );
    if (!context.mounted) return;
    if (picked == null) return;

    final iso =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    cubit.selectScheduledDeliveryWithDate(iso);
    onDeliverySelectionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.recipientDetails,
          style: (context) => AppTextStyles.heading1(
            context,
          ).copyWith(fontSize: 24, height: 1.2),
        ),

        SizedBox(height: AppSpacing.md),

        AppTextField(
          label: l10n.recipientNameHint,
          hint: l10n.recipientNameHint,
          controller: nameController,
          errorText: recipientNameErrorText,
          onChanged: onRecipientNameChanged,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.recipientEmail,
          hint: l10n.recipientEmailHintGmail,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          errorText: recipientEmailErrorText,
          onChanged: onRecipientEmailChanged,
        ),
        SizedBox(height: AppSpacing.md),
        PhoneNumberField(
          label: l10n.recipientPhoneOptional,
          countryCode: '+966',
          flagAsset: '',
          controller: phoneController,
          maxPhoneDigits: 10,
          errorText: recipientPhoneErrorText,
          onChanged: onRecipientPhoneChanged,
          onCountryChanged: (countryCode) {
            onCountryCodeChanged(countryCode.dialCode ?? '+966');
          },
        ),
        SizedBox(height: AppSpacing.md),

        AppText(l10n.deliveryOptions, style: AppTextStyles.textFieldHeading),
        SizedBox(height: AppSpacing.base),

        BlocBuilder<GiftSubscriptionCubit, GiftSubscriptionState>(
          buildWhen: (p, c) =>
              p.selectedDeliveryOption != c.selectedDeliveryOption ||
              p.scheduledDeliveryDateIso != c.scheduledDeliveryDateIso,
          builder: (context, state) {
            final options = state.deliveryOptions;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: () => _onDeliveryTileTap(context, options[i]),
                    child: DeliveryOptionTile(
                      label: getLabel(options[i], l10n),
                      isSelected: state.selectedDeliveryOption == options[i],
                    ),
                  ),
                ],
                if (state.selectedDeliveryOption ==
                        DeliveryOption.scheduledDelivery &&
                    (state.scheduledDeliveryDateIso?.isNotEmpty ?? false)) ...[
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: isDark
                            ? AppColors.languageIconDark
                            : AppColors.languageIcon,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppText(
                          '${l10n.date}: ${_formatScheduledDate(context, state.scheduledDeliveryDateIso!)}',
                          style: (c) => AppTextStyles.bodyText(
                            c,
                          ).copyWith(fontWeight: FontWeight.w500, height: 1.35),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
                if (deliveryDateErrorText != null) ...[
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: isDark ? AppColors.redDark : AppColors.redLight,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          deliveryDateErrorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.redDark
                                    : AppColors.redLight,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),

        SizedBox(height: AppSpacing.md),

        AppTextField(
          label: l10n.personalMessageOptional,
          hint: l10n.personalMessageHint,
          maxLines: 4,
          controller: messageController,
        ),
        SizedBox(height: AppSpacing.sm),
        AppText(
          l10n.charactersCount,
          style: (context) => AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.lightGrey, height: 1.5),
        ),
      ],
    );
  }

  String getLabel(DeliveryOption deliveryOption, AppLocalizations l10n) {
    switch (deliveryOption) {
      case DeliveryOption.instantDelivery:
        return l10n.instantDelivery;

      case DeliveryOption.scheduledDelivery:
        return l10n.scheduledDelivery1;
    }
  }
}
