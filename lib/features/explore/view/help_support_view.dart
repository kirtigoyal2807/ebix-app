import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/utils/support_launcher.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constant.dart';
import '../../../widgets/app_app_bar.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.helpSupport,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              onTap: () =>
                  _openSupport(context, () => SupportLauncher.openWhatsApp()),
              icon: isDark
                  ? 'assets/images/svg/explore/ic_dark_chat.svg'
                  : 'assets/images/svg/explore/ic_chat.svg',
              title: context.l10n.liveChat,
              subtitle: context.l10n.liveChatDesc,
            ),
            SizedBox(height: AppSpacing.md),
            _buildCard(
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: AppConstant.supportEmail,
                );

                launchUrl(emailLaunchUri);
              },
              icon: isDark
                  ? 'assets/images/svg/explore/ic_dark_email.svg'
                  : 'assets/images/svg/explore/Ic_email.svg',
              title: context.l10n.emailSupport,
              subtitle: context.l10n.emailSupportDesc,
            ),
            SizedBox(height: AppSpacing.md),
            _buildCard(
              onTap: () async {
                final Uri url = Uri.parse("tel:${AppConstant.supportNumber}");

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw "Cannot open dialer";
                }
              },
              icon: isDark
                  ? "assets/images/svg/explore/ic_dark_phone.svg"
                  : 'assets/images/svg/explore/ic_phone.svg',
              title: context.l10n.phoneSupport,
              subtitle: context.l10n.phoneSupportDesc,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText(
                title,
                style: (context) => AppTextStyles.textFieldHeading(
                  context,
                ).copyWith(height: 1.60),
              ),
              SizedBox(height: 2),
              AppText(
                subtitle,
                style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                  context,
                ).copyWith(height: 1.60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _openSupport(
  BuildContext context,
  Future<bool> Function() launch,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final message = context.l10n.loginErrorGeneric;
  Navigator.of(context).pop();
  final ok = await launch();
  if (ok) return;
  messenger?.showSnackBar(
    SnackBar(content: AppText(message, style: AppTextStyles.body)),
  );
}
