import 'package:url_launcher/url_launcher.dart';

/// Opens PayTabs (or other) hosted checkout URLs from [POST …/checkout/…/payment/intent].
final class CheckoutPaymentLauncher {
  CheckoutPaymentLauncher._();

  /// Tries external browser first (typical for PSP redirects), then in-app / platform.
  static Future<bool> openHostedPaymentUrl(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) return false;
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return false;
    }
    const modes = <LaunchMode>[
      LaunchMode.externalApplication,
      LaunchMode.inAppBrowserView,
      LaunchMode.platformDefault,
    ];
    for (final mode in modes) {
      try {
        if (await launchUrl(uri, mode: mode)) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }
}
