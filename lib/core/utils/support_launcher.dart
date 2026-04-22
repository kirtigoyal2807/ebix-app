import 'package:url_launcher/url_launcher.dart';

import '../constants/support_contact.dart';

/// Opens WhatsApp, email, or phone dialer for [SupportContact] values.
final class SupportLauncher {
  SupportLauncher._();

  static Future<bool> openWhatsApp() {
    final digits = supportPhoneDigits;
    if (digits.isEmpty) return Future.value(false);
    return _launch(
      Uri.parse('https://wa.me/$digits'),
    );
  }

  static Future<bool> openEmail() {
    return _launch(
      Uri.parse('mailto:${SupportContact.supportEmail}'),
    );
  }

  static Future<bool> openPhone() {
    return _launch(
      Uri.parse('tel:${SupportContact.supportPhoneE164}'),
    );
  }

  static String get supportPhoneDigits =>
      SupportContact.supportPhoneE164.replaceAll(RegExp(r'[^0-9]'), '');

  static Future<bool> _launch(Uri uri) {
    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
