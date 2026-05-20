import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// OS-level push notification permission (iOS alert + Android 13+ POST_NOTIFICATIONS).
abstract final class NotificationPermissionService {
  static bool get _isMobile =>
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  static Future<bool> get isGranted async {
    if (!_isMobile) return false;
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited;
  }

  static Future<bool> get isPermanentlyDenied async {
    if (!_isMobile) return false;
    return (await Permission.notification.status).isPermanentlyDenied;
  }

  /// Prompts when permission is not granted yet (new installs + existing users).
  static Future<bool> requestIfNeeded() async {
    if (!_isMobile) return false;

    var status = await Permission.notification.status;
    if (status.isGranted || status.isLimited) return true;
    if (status.isPermanentlyDenied || status.isRestricted) return false;

    status = await Permission.notification.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> openSystemSettings() => openAppSettings();
}
