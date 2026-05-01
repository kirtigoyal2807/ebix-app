import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pilates_app/core/utils/hosted_payment_webview_page.dart';

/// Opens PayTabs (or other) hosted checkout URLs from [POST …/checkout/…/payment/intent].
final class CheckoutPaymentLauncher {
  CheckoutPaymentLauncher._();

  /// Full-screen WebView: parses JSON success body (PayTabs callback) or success
  /// query params, then pops with [HostedPaymentWebViewResult] so callers can
  /// refresh checkout and navigate to the receipt screen.
  static Future<HostedPaymentWebViewResult?> openInAppPaymentWebView(
    BuildContext context,
    String? rawUrl,
  ) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return null;
    }
    return Navigator.of(context).push<HostedPaymentWebViewResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => HostedPaymentWebViewPage(initialUrl: uri.toString()),
      ),
    );
  }

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
