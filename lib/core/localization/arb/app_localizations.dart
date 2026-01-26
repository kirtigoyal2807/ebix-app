import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @onboarding_title_1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pilates'**
  String get onboarding_title_1;

  /// No description provided for @onboarding_desc_1.
  ///
  /// In en, this message translates to:
  /// **'Improve your strength and flexibility with guided sessions.'**
  String get onboarding_desc_1;

  /// No description provided for @onboarding_title_2.
  ///
  /// In en, this message translates to:
  /// **'Move with intention, strength, and balance.'**
  String get onboarding_title_2;

  /// No description provided for @onboarding_desc_2.
  ///
  /// In en, this message translates to:
  /// **'Build strength, flexibility, and calm through guided Pilates sessions made for you.'**
  String get onboarding_desc_2;

  /// No description provided for @onboarding_title_3.
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboarding_title_3;

  /// No description provided for @onboarding_desc_3.
  ///
  /// In en, this message translates to:
  /// **'Monitor your improvement and stay motivated.'**
  String get onboarding_desc_3;

  /// No description provided for @noExperienceNeeded.
  ///
  /// In en, this message translates to:
  /// **'No experience needed'**
  String get noExperienceNeeded;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageCode;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get changeLanguage;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password and add your phone'**
  String get createPassword;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with a mix of letters and numbers'**
  String get passwordHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyOtp;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email'**
  String get otpHint;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? Resend Code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Pilates experience'**
  String get experienceTitle;

  /// No description provided for @experienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your journey'**
  String get experienceSubtitle;

  /// No description provided for @experienceBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get experienceBeginner;

  /// No description provided for @experienceBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'New to Pilates or just starting out'**
  String get experienceBeginnerDesc;

  /// No description provided for @experienceIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get experienceIntermediate;

  /// No description provided for @experienceIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Comfortable with basics, ready to progress'**
  String get experienceIntermediateDesc;

  /// No description provided for @experienceAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get experienceAdvanced;

  /// No description provided for @experienceAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Experienced practitioner seeking challenge'**
  String get experienceAdvancedDesc;

  /// No description provided for @branchTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your home studio'**
  String get branchTitle;

  /// No description provided for @branchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred location'**
  String get branchSubtitle;

  /// No description provided for @branchDowntown.
  ///
  /// In en, this message translates to:
  /// **'Downtown Studio'**
  String get branchDowntown;

  /// No description provided for @branchDowntownAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Main Street'**
  String get branchDowntownAddress;

  /// No description provided for @branchUptown.
  ///
  /// In en, this message translates to:
  /// **'Uptown Studio'**
  String get branchUptown;

  /// No description provided for @branchUptownAddress.
  ///
  /// In en, this message translates to:
  /// **'456 North Avenue'**
  String get branchUptownAddress;

  /// No description provided for @finishSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get finishSignUp;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @liveChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat with our team • Available 9 AM - 9 PM'**
  String get liveChatDesc;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @emailSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'support@thepilatesstudio.com'**
  String get emailSupportDesc;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @phoneSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'91 98765 43210 • Mon-Sat 9 AM - 7 PM'**
  String get phoneSupportDesc;

  /// No description provided for @splashAppName.
  ///
  /// In en, this message translates to:
  /// **'The Pilates'**
  String get splashAppName;

  /// No description provided for @splashStudio.
  ///
  /// In en, this message translates to:
  /// **'STUDIO'**
  String get splashStudio;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Pilates Journey Begins'**
  String get splashTagline;

  /// No description provided for @splashVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0'**
  String get splashVersion;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get to know you'**
  String get letsGo;

  /// No description provided for @tellYourName.
  ///
  /// In en, this message translates to:
  /// **'Tell us your name and email'**
  String get tellYourName;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure your account'**
  String get secureYourAccount;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone'**
  String get verifyPhone;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to'**
  String get enterCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
