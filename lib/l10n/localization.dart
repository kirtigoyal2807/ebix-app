import 'package:flutter/material.dart';

/// Simple localization - just use Localization.get('key')
class Localization {
  static Locale _currentLocale = const Locale('en');

  /// Change the current locale
  static void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  /// Get current locale
  static Locale get currentLocale => _currentLocale;

  /// Check if Arabic is active
  static bool get isArabic => _currentLocale.languageCode == 'ar';

  // Translation map - add your strings here
  static final Map<String, Map<String, String>> _translations = {
    'appTitle': {'en': 'Pilates App', 'ar': 'تطبيق بيلاتس'},
    'appSubtitle': {'en': 'Your fitness companion', 'ar': 'رفيقك في اللياقة البدنية'},
    'homeWelcome': {'en': 'Welcome to Pilates', 'ar': 'أهلا بك في بيلاتس'},
    'homeDescription': {'en': 'Start your workout journey', 'ar': 'ابدأ رحلة تمرينك'},
    'currentTheme': {'en': 'Current Theme', 'ar': 'المظهر الحالي'},
    'currentLanguage': {'en': 'Current Language', 'ar': 'اللغة الحالية'},
    'goToSettings': {'en': 'Go to Settings', 'ar': 'انتقل إلى الإعدادات'},
    'settingsTitle': {'en': 'Settings', 'ar': 'الإعدادات'},
    'selectTheme': {'en': 'Select Theme', 'ar': 'اختر المظهر'},
    'lightMode': {'en': 'Light Mode', 'ar': 'الوضع الفاتح'},
    'darkMode': {'en': 'Dark Mode', 'ar': 'الوضع الداكن'},
    'systemDefault': {'en': 'System Default', 'ar': 'الإعداد الافتراضي للنظام'},
    'selectLanguage': {'en': 'Select Language', 'ar': 'اختر اللغة'},
    'english': {'en': 'English', 'ar': 'English'},
    'arabic': {'en': 'العربية', 'ar': 'العربية'},
    'aboutApp': {'en': 'About This App', 'ar': 'حول التطبيق'},
    'aboutDescription': {'en': 'Pilates App v1.0.0\nYour complete fitness solution', 'ar': 'تطبيق بيلاتس v1.0.0\nحلك الشامل للياقة البدنية'},
    'back': {'en': 'Back', 'ar': 'رجوع'},
    'close': {'en': 'Close', 'ar': 'إغلاق'},
    'ok': {'en': 'OK', 'ar': 'حسناً'},
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
    'save': {'en': 'Save', 'ar': 'حفظ'},
    'loading': {'en': 'Loading...', 'ar': 'جاري التحميل...'},
  };

  /// Get string by key
  static String get(String key) {
    final lang = isArabic ? 'ar' : 'en';
    return _translations[key]?[lang] ?? key;
  }

  /// Add a new string dynamically
  static void addString(String key, String en, String ar) {
    _translations[key] = {'en': en, 'ar': ar};
  }
}
