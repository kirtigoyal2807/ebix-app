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
  /// **'Move with intention,\nstrength, and balance.'**
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

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @offf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get offf;

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
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

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

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **' Resend Code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll recommend classes and instructors that match your level'**
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
  /// **'Complete Setup'**
  String get finishSignUp;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Chat on WhatsApp'**
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
  /// **'Enter the 6-digit code sent to'**
  String get enterCode;

  /// No description provided for @phoneVerificationMissingPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is missing. Go back and continue registration again.'**
  String get phoneVerificationMissingPhone;

  /// No description provided for @phoneVerificationEnterSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit verification code.'**
  String get phoneVerificationEnterSixDigits;

  /// No description provided for @continueTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTxt;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @selectedBranch.
  ///
  /// In en, this message translates to:
  /// **'Selected Branch'**
  String get selectedBranch;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @enterYourLoginDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your login details'**
  String get enterYourLoginDetails;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email / Phone Number'**
  String get emailOrPhone;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @emailTab.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTab;

  /// No description provided for @phoneTab.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneTab;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterEmailHeader.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterEmailHeader;

  /// No description provided for @enterEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the email address associated with your account. We\'ll send you a link to reset your password and regain access.'**
  String get enterEmailSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationTitle;

  /// No description provided for @otpVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your email to verify your identity. Once verified, you can proceed to reset your password.'**
  String get otpVerificationSubtitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'username@gmail.com'**
  String get usernameHint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @dontWorry.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry — you can change this anytime in settings'**
  String get dontWorry;

  /// No description provided for @createNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPasswordTitle;

  /// No description provided for @createNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong new password for your account. Make sure it\'s unique and different from your previous passwords to keep your account secure.'**
  String get createNewPasswordSubtitle;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String hiUser(String name);

  /// No description provided for @readyToFlow.
  ///
  /// In en, this message translates to:
  /// **'Ready to flow?'**
  String get readyToFlow;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @exploreBranches.
  ///
  /// In en, this message translates to:
  /// **'Explore Branches'**
  String get exploreBranches;

  /// No description provided for @viewSchedule.
  ///
  /// In en, this message translates to:
  /// **'View Schedule'**
  String get viewSchedule;

  /// No description provided for @springResetChallenge.
  ///
  /// In en, this message translates to:
  /// **'Spring Reset Challenge'**
  String get springResetChallenge;

  /// No description provided for @springResetDesc.
  ///
  /// In en, this message translates to:
  /// **'21 days to increased energy'**
  String get springResetDesc;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startYourJourney;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @classTxt.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classTxt;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @ofClassesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{attended} of {count} classes this month'**
  String ofClassesThisMonth(int attended, int count);

  /// No description provided for @featuredClass.
  ///
  /// In en, this message translates to:
  /// **'Featured Class'**
  String get featuredClass;

  /// No description provided for @inYourPlan.
  ///
  /// In en, this message translates to:
  /// **'In Your Plan'**
  String get inYourPlan;

  /// No description provided for @withKey.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get withKey;

  /// No description provided for @withTrainer.
  ///
  /// In en, this message translates to:
  /// **'{trainer}'**
  String withTrainer(String trainer);

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} spots left'**
  String spotsLeft(int count);

  /// No description provided for @bookClass.
  ///
  /// In en, this message translates to:
  /// **'Book Class'**
  String get bookClass;

  /// No description provided for @membershipExpired.
  ///
  /// In en, this message translates to:
  /// **'Membership Expired'**
  String get membershipExpired;

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String expiredOn(String date);

  /// No description provided for @renew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get renew;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @startJourneyToday.
  ///
  /// In en, this message translates to:
  /// **'Start your Pilates journey today'**
  String get startJourneyToday;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @unlimitedClasses.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Classes'**
  String get unlimitedClasses;

  /// No description provided for @startYourPilatesJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Pilates Journey'**
  String get startYourPilatesJourney;

  /// No description provided for @bookFirstClassDesc.
  ///
  /// In en, this message translates to:
  /// **'Book your first class to begin tracking your progress and achieving your wellness goals.'**
  String get bookFirstClassDesc;

  /// No description provided for @bookYourFirstClass.
  ///
  /// In en, this message translates to:
  /// **'Book Your First Class'**
  String get bookYourFirstClass;

  /// No description provided for @classTypes.
  ///
  /// In en, this message translates to:
  /// **'Class Types'**
  String get classTypes;

  /// No description provided for @topTrainers.
  ///
  /// In en, this message translates to:
  /// **'Top Trainers'**
  String get topTrainers;

  /// No description provided for @viewClasses.
  ///
  /// In en, this message translates to:
  /// **'View Classes'**
  String get viewClasses;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @classesNav.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classesNav;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yourMembership.
  ///
  /// In en, this message translates to:
  /// **'Your Membership'**
  String get yourMembership;

  /// No description provided for @hoursCount.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String hoursCount(String count);

  /// No description provided for @classTypeReformer.
  ///
  /// In en, this message translates to:
  /// **'Reformer'**
  String get classTypeReformer;

  /// No description provided for @classTypeCadillac.
  ///
  /// In en, this message translates to:
  /// **'Cadillac'**
  String get classTypeCadillac;

  /// No description provided for @classTypeFlow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get classTypeFlow;

  /// No description provided for @trainerGroundedFlow.
  ///
  /// In en, this message translates to:
  /// **'Grounded Flow'**
  String get trainerGroundedFlow;

  /// No description provided for @powerPilates.
  ///
  /// In en, this message translates to:
  /// **'Power Pilates'**
  String get powerPilates;

  /// No description provided for @trainers.
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get trainers;

  /// No description provided for @searchClassesHint.
  ///
  /// In en, this message translates to:
  /// **'Search classes...'**
  String get searchClassesHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @allGender.
  ///
  /// In en, this message translates to:
  /// **'All Gender'**
  String get allGender;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get allDates;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @thisWeekend.
  ///
  /// In en, this message translates to:
  /// **'This Weekend'**
  String get thisWeekend;

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get allBranches;

  /// No description provided for @branch1.
  ///
  /// In en, this message translates to:
  /// **'Branch 1'**
  String get branch1;

  /// No description provided for @branch2.
  ///
  /// In en, this message translates to:
  /// **'Branch 2'**
  String get branch2;

  /// No description provided for @branch3.
  ///
  /// In en, this message translates to:
  /// **'Branch 3'**
  String get branch3;

  /// No description provided for @branch4.
  ///
  /// In en, this message translates to:
  /// **'Branch 4'**
  String get branch4;

  /// No description provided for @branch5.
  ///
  /// In en, this message translates to:
  /// **'Branch 5'**
  String get branch5;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @upgradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Required'**
  String get upgradeRequired;

  /// No description provided for @classDetails.
  ///
  /// In en, this message translates to:
  /// **'Class Details'**
  String get classDetails;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @aboutThisClass.
  ///
  /// In en, this message translates to:
  /// **'About this class'**
  String get aboutThisClass;

  /// No description provided for @whatToBring.
  ///
  /// In en, this message translates to:
  /// **'What to bring'**
  String get whatToBring;

  /// No description provided for @recentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recentReviews;

  /// No description provided for @bookThisClass.
  ///
  /// In en, this message translates to:
  /// **'Book This Class'**
  String get bookThisClass;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesCount(Object count);

  /// No description provided for @bookYourClass.
  ///
  /// In en, this message translates to:
  /// **'Book Your Class'**
  String get bookYourClass;

  /// No description provided for @paymentSummery.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummery;

  /// No description provided for @classFee.
  ///
  /// In en, this message translates to:
  /// **'Class Fee'**
  String get classFee;

  /// No description provided for @bookingPriceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get bookingPriceUnavailable;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @bookPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the cancellation policy and understand that I can cancel up to 4 hours before the class starts.'**
  String get bookPolicy;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successfully'**
  String get bookingSuccess;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set for your class.'**
  String get successMessage;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkIn;

  /// No description provided for @checkInDescription.
  ///
  /// In en, this message translates to:
  /// **'Check-in opens 30 minutes before class (Available at 5:30 PM)'**
  String get checkInDescription;

  /// No description provided for @checkInLongDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive a notification when check-in becomes available'**
  String get checkInLongDescription;

  /// No description provided for @checkInButton.
  ///
  /// In en, this message translates to:
  /// **'Check-In (Opens at 5:30 PM)'**
  String get checkInButton;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'You\'re checked in.'**
  String get checkInSuccess;

  /// No description provided for @checkInWindowExplanationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Check-in opens {minutes} minutes before class (Available at {time})'**
  String checkInWindowExplanationSchedule(int minutes, String time);

  /// No description provided for @checkInButtonOpensAtDynamic.
  ///
  /// In en, this message translates to:
  /// **'Check-In (Opens at {time})'**
  String checkInButtonOpensAtDynamic(String time);

  /// No description provided for @checkInEndedForThisClass.
  ///
  /// In en, this message translates to:
  /// **'Check-in is closed for this class.'**
  String get checkInEndedForThisClass;

  /// No description provided for @checkInActiveWindowBody.
  ///
  /// In en, this message translates to:
  /// **'You can check in now.'**
  String get checkInActiveWindowBody;

  /// No description provided for @checkInOpensAtHint.
  ///
  /// In en, this message translates to:
  /// **'Opens {time}'**
  String checkInOpensAtHint(String time);

  /// No description provided for @checkInClosedShort.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get checkInClosedShort;

  /// No description provided for @cancelEnrollmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your booking was cancelled.'**
  String get cancelEnrollmentSuccess;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get checkedIn;

  /// No description provided for @classDetail.
  ///
  /// In en, this message translates to:
  /// **'Class Details'**
  String get classDetail;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @addToCalender.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalender;

  /// No description provided for @getDirection.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirection;

  /// No description provided for @cancelPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'I agree to the cancellation policy and understand that I can cancel up to 4 hours before the class starts.'**
  String get cancelPolicyDescription;

  /// No description provided for @acceptPolicyToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please accept the cancellation policy to continue.'**
  String get acceptPolicyToContinue;

  /// No description provided for @viewMyBooking.
  ///
  /// In en, this message translates to:
  /// **'View My Booking'**
  String get viewMyBooking;

  /// No description provided for @browseMoreClasses.
  ///
  /// In en, this message translates to:
  /// **'Browse More Classes'**
  String get browseMoreClasses;

  /// No description provided for @joinWailList.
  ///
  /// In en, this message translates to:
  /// **'Join Waitlist'**
  String get joinWailList;

  /// No description provided for @classIsFull.
  ///
  /// In en, this message translates to:
  /// **'Class Is Full'**
  String get classIsFull;

  /// No description provided for @classIsFullDescription.
  ///
  /// In en, this message translates to:
  /// **'Join the waitlist and we\'ll notify you immediately if a spot opens up.'**
  String get classIsFullDescription;

  /// No description provided for @currentWaitList.
  ///
  /// In en, this message translates to:
  /// **'Current Waitlist'**
  String get currentWaitList;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @smartTip.
  ///
  /// In en, this message translates to:
  /// **'Smart Waitlist Tip'**
  String get smartTip;

  /// No description provided for @smartTipDescription.
  ///
  /// In en, this message translates to:
  /// **'Based on historical data, this class typically has 2-3 cancellations. Your chances of getting in are high!'**
  String get smartTipDescription;

  /// No description provided for @joinWaitList.
  ///
  /// In en, this message translates to:
  /// **'Join Waitlist'**
  String get joinWaitList;

  /// No description provided for @browseOtherClasses.
  ///
  /// In en, this message translates to:
  /// **'Browse Other Classes'**
  String get browseOtherClasses;

  /// No description provided for @onWaitList.
  ///
  /// In en, this message translates to:
  /// **'On Waitlist'**
  String get onWaitList;

  /// No description provided for @onWaitListDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you if a spot opens up'**
  String get onWaitListDescription;

  /// No description provided for @yourPosition.
  ///
  /// In en, this message translates to:
  /// **'Your Position'**
  String get yourPosition;

  /// No description provided for @inLine.
  ///
  /// In en, this message translates to:
  /// **'In Line'**
  String get inLine;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy: Free cancellation up to 4 hours before class. Late cancellations may incur a fee.'**
  String get cancelBooking;

  /// No description provided for @classDescriptionShort.
  ///
  /// In en, this message translates to:
  /// **'Build strength, flexibility, and calm through guided Pilates sessions.'**
  String get classDescriptionShort;

  /// No description provided for @trainerAishaSherin.
  ///
  /// In en, this message translates to:
  /// **'Aisha Sherin'**
  String get trainerAishaSherin;

  /// No description provided for @branchAddressDetail.
  ///
  /// In en, this message translates to:
  /// **'123 Main Street, Suite 200'**
  String get branchAddressDetail;

  /// No description provided for @aboutClassDescription.
  ///
  /// In en, this message translates to:
  /// **'This dynamic class focuses on building core strength and improving flexibility. Perfect for all levels, you\'ll flow through a series of controlled movements that challenge your body while promoting mindfulness and balance.'**
  String get aboutClassDescription;

  /// No description provided for @itemAttire.
  ///
  /// In en, this message translates to:
  /// **'Comfortable workout attire'**
  String get itemAttire;

  /// No description provided for @itemWater.
  ///
  /// In en, this message translates to:
  /// **'Water bottle'**
  String get itemWater;

  /// No description provided for @itemTowel.
  ///
  /// In en, this message translates to:
  /// **'Towel (optional)'**
  String get itemTowel;

  /// No description provided for @itemMat.
  ///
  /// In en, this message translates to:
  /// **'Mat provided at studio'**
  String get itemMat;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @basedOnReviews.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} reviews'**
  String basedOnReviews(int count);

  /// No description provided for @reviewerName1.
  ///
  /// In en, this message translates to:
  /// **'Jessica M.'**
  String get reviewerName1;

  /// No description provided for @reviewerTime1.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get reviewerTime1;

  /// No description provided for @reviewerComment1.
  ///
  /// In en, this message translates to:
  /// **'\"Sarah is incredible! Her classes are challenging but she makes sure everyone feels supported. I\'ve seen amazing progress in my core strength.\"'**
  String get reviewerComment1;

  /// No description provided for @branchNotInPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Branch not in your plan'**
  String get branchNotInPlanTitle;

  /// No description provided for @branchNotInPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Westside Studio is not included in your Premium Plan. Upgrade your plan or pay per class to access this location.'**
  String get branchNotInPlanDescription;

  /// No description provided for @yourPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Plan'**
  String get yourPlan;

  /// No description provided for @neededPlan.
  ///
  /// In en, this message translates to:
  /// **'Needed:'**
  String get neededPlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlan;

  /// No description provided for @elitePlan.
  ///
  /// In en, this message translates to:
  /// **'Elite Plan (All locations)'**
  String get elitePlan;

  /// No description provided for @upgradeToElite.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Elite Plan'**
  String get upgradeToElite;

  /// No description provided for @paySingleClass.
  ///
  /// In en, this message translates to:
  /// **'Pay \$24 for Single Class'**
  String get paySingleClass;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noClassesToday.
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get noClassesToday;

  /// No description provided for @noClassesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your upcoming bookings or\nbrowse available classes'**
  String get noClassesDescription;

  /// No description provided for @noUpcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'No upcoming classes'**
  String get noUpcomingClasses;

  /// No description provided for @noCurrentClasses.
  ///
  /// In en, this message translates to:
  /// **'No current classes'**
  String get noCurrentClasses;

  /// No description provided for @noPastClasses.
  ///
  /// In en, this message translates to:
  /// **'No past classes'**
  String get noPastClasses;

  /// No description provided for @noCancelledClasses.
  ///
  /// In en, this message translates to:
  /// **'No cancelled classes'**
  String get noCancelledClasses;

  /// No description provided for @noUpcomingClassesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your plan or browse available classes to book one.'**
  String get noUpcomingClassesDescription;

  /// No description provided for @noCurrentClassesDescription.
  ///
  /// In en, this message translates to:
  /// **'You have no class in progress at the moment.'**
  String get noCurrentClassesDescription;

  /// No description provided for @noPastClassesDescription.
  ///
  /// In en, this message translates to:
  /// **'Classes you have completed will appear here.'**
  String get noPastClassesDescription;

  /// No description provided for @noCancelledClassesDescription.
  ///
  /// In en, this message translates to:
  /// **'You have no cancelled class bookings here.'**
  String get noCancelledClassesDescription;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @waitlisted.
  ///
  /// In en, this message translates to:
  /// **'Waitlisted'**
  String get waitlisted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @spot.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get spot;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'No, keep it'**
  String get keepIt;

  /// No description provided for @leaveWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Leave Waitlist'**
  String get leaveWaitlist;

  /// No description provided for @rateThisClass.
  ///
  /// In en, this message translates to:
  /// **'Rate This Class'**
  String get rateThisClass;

  /// No description provided for @cancelClassConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your class?'**
  String get cancelClassConfirm;

  /// No description provided for @cancelClassYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get cancelClassYes;

  /// No description provided for @leaveWaitlistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the waitlist?'**
  String get leaveWaitlistConfirm;

  /// No description provided for @leaveWaitlistYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, Leave'**
  String get leaveWaitlistYes;

  /// No description provided for @positionOnWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Position #{position} on waitlist'**
  String positionOnWaitlist(Object position);

  /// No description provided for @cancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled on {date} at {time}'**
  String cancelledOn(Object date, Object time);

  /// No description provided for @excellentReview.
  ///
  /// In en, this message translates to:
  /// **'Excellent class! Sarah is an amazing instructor.'**
  String get excellentReview;

  /// No description provided for @rateYourClass.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Class'**
  String get rateYourClass;

  /// No description provided for @rateYourClassDesc.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with {className}?'**
  String rateYourClassDesc(Object className);

  /// No description provided for @rateYourTrainer.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Trainer'**
  String get rateYourTrainer;

  /// No description provided for @rateYourTrainerDesc.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with {trainerName}?'**
  String rateYourTrainerDesc(Object trainerName);

  /// No description provided for @writeDetailedReview.
  ///
  /// In en, this message translates to:
  /// **'Write Detailed Review'**
  String get writeDetailedReview;

  /// No description provided for @shareExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience (optional)'**
  String get shareExperienceHint;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @signInToRateTrainer.
  ///
  /// In en, this message translates to:
  /// **'Sign in to rate this trainer.'**
  String get signInToRateTrainer;

  /// No description provided for @reviewSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your review was submitted. Thank you!'**
  String get reviewSubmittedSuccess;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get tabCurrent;

  /// No description provided for @tabPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tabPast;

  /// No description provided for @tabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tabCancelled;

  /// No description provided for @reviewExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent class! Sarah is an amazing instructor.'**
  String get reviewExcellent;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get chooseYourPlan;

  /// No description provided for @selectPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the plan that works best for you'**
  String get selectPlanSubtitle;

  /// No description provided for @buyAsGift.
  ///
  /// In en, this message translates to:
  /// **'Buy as Gift'**
  String get buyAsGift;

  /// No description provided for @perfectForFriends.
  ///
  /// In en, this message translates to:
  /// **'Perfect for friends & family'**
  String get perfectForFriends;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @starter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get starter;

  /// No description provided for @premiumPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlanTitle;

  /// No description provided for @basicPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get basicPlanTitle;

  /// No description provided for @unlimitedPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Plan'**
  String get unlimitedPlanTitle;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @feature12Classes.
  ///
  /// In en, this message translates to:
  /// **'12 classes per month'**
  String get feature12Classes;

  /// No description provided for @featureDowntownUptown.
  ///
  /// In en, this message translates to:
  /// **'Downtown + uptown studios'**
  String get featureDowntownUptown;

  /// No description provided for @featureFreeMatEquipment.
  ///
  /// In en, this message translates to:
  /// **'Free mat + equipment rental'**
  String get featureFreeMatEquipment;

  /// No description provided for @featurePriorityBooking.
  ///
  /// In en, this message translates to:
  /// **'Priority booking'**
  String get featurePriorityBooking;

  /// No description provided for @feature8Classes.
  ///
  /// In en, this message translates to:
  /// **'8 classes per month'**
  String get feature8Classes;

  /// No description provided for @featureDowntownOnly.
  ///
  /// In en, this message translates to:
  /// **'Downtown studio only'**
  String get featureDowntownOnly;

  /// No description provided for @featureFreeMat.
  ///
  /// In en, this message translates to:
  /// **'Free mat rental'**
  String get featureFreeMat;

  /// No description provided for @featureUnlimitedClasses.
  ///
  /// In en, this message translates to:
  /// **'Unlimited classes'**
  String get featureUnlimitedClasses;

  /// No description provided for @featureAllStudios.
  ///
  /// In en, this message translates to:
  /// **'All studios access'**
  String get featureAllStudios;

  /// No description provided for @featurePriorityGuest.
  ///
  /// In en, this message translates to:
  /// **'Priority booking + Guest passes'**
  String get featurePriorityGuest;

  /// No description provided for @healthInformation.
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @chronicConditions.
  ///
  /// In en, this message translates to:
  /// **'Do you have any chronic medical conditions? (e.g., high blood pressure, diabetes, heart disease)'**
  String get chronicConditions;

  /// No description provided for @surgeriesInjuries.
  ///
  /// In en, this message translates to:
  /// **'Have you had any recent surgeries or do you have any current injuries?'**
  String get surgeriesInjuries;

  /// No description provided for @painBonesMuscles.
  ///
  /// In en, this message translates to:
  /// **'Do you have any pain or problems in bones, joints, or muscles?'**
  String get painBonesMuscles;

  /// No description provided for @respiratoryProblems.
  ///
  /// In en, this message translates to:
  /// **'Do you have any respiratory, heart, or lung problems?'**
  String get respiratoryProblems;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Do you take any medications regularly?'**
  String get medications;

  /// No description provided for @highBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'High Blood Pressure'**
  String get highBloodPressure;

  /// No description provided for @diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @heartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart Disease'**
  String get heartDisease;

  /// No description provided for @heartCondition.
  ///
  /// In en, this message translates to:
  /// **'Heart condition'**
  String get heartCondition;

  /// No description provided for @noneOfTheAbove.
  ///
  /// In en, this message translates to:
  /// **'None of the above'**
  String get noneOfTheAbove;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @hearProblems.
  ///
  /// In en, this message translates to:
  /// **'Hear Problems'**
  String get hearProblems;

  /// No description provided for @lungProblems.
  ///
  /// In en, this message translates to:
  /// **'Lung Problems'**
  String get lungProblems;

  /// No description provided for @respiratoryProblem.
  ///
  /// In en, this message translates to:
  /// **'Respiratory Problem'**
  String get respiratoryProblem;

  /// No description provided for @physicalActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity Level'**
  String get physicalActivityLevel;

  /// No description provided for @doYouExerciseRegularly.
  ///
  /// In en, this message translates to:
  /// **'Do you exercise regularly?'**
  String get doYouExerciseRegularly;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @sometimes.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get sometimes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ifYesHowManyTimes.
  ///
  /// In en, this message translates to:
  /// **'If yes, how many times per week?'**
  String get ifYesHowManyTimes;

  /// No description provided for @physicalActivityStepIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please complete all physical activity questions before continuing.'**
  String get physicalActivityStepIncomplete;

  /// No description provided for @daysAWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} days a week'**
  String daysAWeek(int count);

  /// No description provided for @pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy (if applicable)'**
  String get pregnancy;

  /// No description provided for @areYouPregnant.
  ///
  /// In en, this message translates to:
  /// **'Are you pregnant?'**
  String get areYouPregnant;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @whatIsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'What is your goal for practicing Pilates?'**
  String get whatIsYourGoal;

  /// No description provided for @enterYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Enter your goals'**
  String get enterYourGoals;

  /// No description provided for @declaration.
  ///
  /// In en, this message translates to:
  /// **'Declaration'**
  String get declaration;

  /// No description provided for @declarationText.
  ///
  /// In en, this message translates to:
  /// **'I declare that all information provided is true and accurate. I understand that any incorrect information may affect my safety during exercises.'**
  String get declarationText;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @declarationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get declarationNameRequired;

  /// No description provided for @declarationSignatureRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your signature.'**
  String get declarationSignatureRequired;

  /// No description provided for @declarationDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select the date.'**
  String get declarationDateRequired;

  /// No description provided for @declarationSignatureInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid signature (at least 2 characters).'**
  String get declarationSignatureInvalid;

  /// No description provided for @declarationDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid date.'**
  String get declarationDateInvalid;

  /// No description provided for @pleaseAcceptTermsCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions to continue.'**
  String get pleaseAcceptTermsCheckbox;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutConfirmationMessage;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @englishShort.
  ///
  /// In en, this message translates to:
  /// **'English (EN)'**
  String get englishShort;

  /// No description provided for @homeBranch.
  ///
  /// In en, this message translates to:
  /// **'Home Branch'**
  String get homeBranch;

  /// No description provided for @updatePreferredStudio.
  ///
  /// In en, this message translates to:
  /// **'Update preferred studio'**
  String get updatePreferredStudio;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @billingSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Billing & Subscriptions'**
  String get billingSubscriptions;

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @viewManagePlans.
  ///
  /// In en, this message translates to:
  /// **'View and manage plans'**
  String get viewManagePlans;

  /// No description provided for @buySubscription.
  ///
  /// In en, this message translates to:
  /// **'Buy Subscription'**
  String get buySubscription;

  /// No description provided for @purchaseNewPlan.
  ///
  /// In en, this message translates to:
  /// **'Purchase a new plan'**
  String get purchaseNewPlan;

  /// No description provided for @giftSubscription.
  ///
  /// In en, this message translates to:
  /// **'Gift Subscription'**
  String get giftSubscription;

  /// No description provided for @sendGiftToSomeone.
  ///
  /// In en, this message translates to:
  /// **'Send a gift to someone'**
  String get sendGiftToSomeone;

  /// No description provided for @invoiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Invoice History'**
  String get invoiceHistory;

  /// No description provided for @viewBillingDocuments.
  ///
  /// In en, this message translates to:
  /// **'View billing documents'**
  String get viewBillingDocuments;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @personalDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, email, phone, photo'**
  String get personalDataSubtitle;

  /// No description provided for @pushNotification.
  ///
  /// In en, this message translates to:
  /// **'Push Notification'**
  String get pushNotification;

  /// No description provided for @manageAlertsReminders.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts & reminders'**
  String get manageAlertsReminders;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'89\$ / Month'**
  String get pricePerMonth;

  /// No description provided for @pauseHistory.
  ///
  /// In en, this message translates to:
  /// **'Pause History'**
  String get pauseHistory;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// No description provided for @pauseSubscription.
  ///
  /// In en, this message translates to:
  /// **'Pause Subscription'**
  String get pauseSubscription;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @featureClasses.
  ///
  /// In en, this message translates to:
  /// **'12 classes per month'**
  String get featureClasses;

  /// No description provided for @featureStudios.
  ///
  /// In en, this message translates to:
  /// **'Downtown + uptown studios'**
  String get featureStudios;

  /// No description provided for @featureEquipment.
  ///
  /// In en, this message translates to:
  /// **'Free mat + equipment rental'**
  String get featureEquipment;

  /// No description provided for @featurePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority booking'**
  String get featurePriority;

  /// No description provided for @featurePause.
  ///
  /// In en, this message translates to:
  /// **'2 pause attempts per year'**
  String get featurePause;

  /// No description provided for @pastPauses.
  ///
  /// In en, this message translates to:
  /// **'Past Pauses'**
  String get pastPauses;

  /// No description provided for @remainingThisYear.
  ///
  /// In en, this message translates to:
  /// **'Remaining This Year'**
  String get remainingThisYear;

  /// No description provided for @pauseAttemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Pause attempts remaining'**
  String get pauseAttemptsRemaining;

  /// No description provided for @attemptCount.
  ///
  /// In en, this message translates to:
  /// **'1 of 2 attempts'**
  String get attemptCount;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get basicPlan;

  /// No description provided for @upgradedFromBasic.
  ///
  /// In en, this message translates to:
  /// **'Upgraded from basic'**
  String get upgradedFromBasic;

  /// No description provided for @initialSubscription.
  ///
  /// In en, this message translates to:
  /// **'Initial Subscription'**
  String get initialSubscription;

  /// No description provided for @sinceDate.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String sinceDate(Object date);

  /// No description provided for @planDuration.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}'**
  String planDuration(Object start, Object end);

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @pauseDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporarily pause your subscription and billing. Your plan benefits will resume when you return.'**
  String get pauseDescription;

  /// No description provided for @cannotPauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot Pause Subscription'**
  String get cannotPauseTitle;

  /// No description provided for @cannotPauseMessage.
  ///
  /// In en, this message translates to:
  /// **'You only have 7 freeze days remaining. Please select a shorter pause period or upgrade your plan.'**
  String get cannotPauseMessage;

  /// No description provided for @selectPausePeriod.
  ///
  /// In en, this message translates to:
  /// **'Select Pause Period'**
  String get selectPausePeriod;

  /// No description provided for @tapToSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Tap to select date'**
  String get tapToSelectDate;

  /// No description provided for @pauseSelectBothDates.
  ///
  /// In en, this message translates to:
  /// **'Please select both a start date and an end date.'**
  String get pauseSelectBothDates;

  /// No description provided for @pausePeriodTooLong.
  ///
  /// In en, this message translates to:
  /// **'Pause cannot exceed {maxDays} days.'**
  String pausePeriodTooLong(int maxDays);

  /// No description provided for @pauseMaxFreezeDaysHint.
  ///
  /// In en, this message translates to:
  /// **'You can pause up to {maxDays} days at a time. Start and end dates must fall within your plan.'**
  String pauseMaxFreezeDaysHint(int maxDays);

  /// No description provided for @pauseSelectStartFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a start date first.'**
  String get pauseSelectStartFirst;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String daysCount(Object count);

  /// No description provided for @pauseAttemptsPerYear.
  ///
  /// In en, this message translates to:
  /// **'2 pause attempts per year'**
  String get pauseAttemptsPerYear;

  /// No description provided for @pauseAttempts.
  ///
  /// In en, this message translates to:
  /// **'Pause attempts'**
  String get pauseAttempts;

  /// No description provided for @attemptRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} attempt remaining'**
  String attemptRemaining(Object count);

  /// No description provided for @duringPausePeriod.
  ///
  /// In en, this message translates to:
  /// **'During Pause Period'**
  String get duringPausePeriod;

  /// No description provided for @noBillingCharges.
  ///
  /// In en, this message translates to:
  /// **'No billing charges will occur'**
  String get noBillingCharges;

  /// No description provided for @noBookingAllowed.
  ///
  /// In en, this message translates to:
  /// **'You cannot book or attend classes'**
  String get noBookingAllowed;

  /// No description provided for @subscriptionExtended.
  ///
  /// In en, this message translates to:
  /// **'Your subscription will extend by the pause duration'**
  String get subscriptionExtended;

  /// No description provided for @nextBillingDate.
  ///
  /// In en, this message translates to:
  /// **'Next billing date will be {date} (extended by {days} days)'**
  String nextBillingDate(Object date, Object days);

  /// No description provided for @creditsPreserved.
  ///
  /// In en, this message translates to:
  /// **'Unused class credits will be preserved'**
  String get creditsPreserved;

  /// No description provided for @confirmPause.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pause'**
  String get confirmPause;

  /// No description provided for @classesUsed.
  ///
  /// In en, this message translates to:
  /// **'Classes used'**
  String get classesUsed;

  /// No description provided for @pauseUsed.
  ///
  /// In en, this message translates to:
  /// **'Pause used'**
  String get pauseUsed;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @existingPlan.
  ///
  /// In en, this message translates to:
  /// **'Existing Plan'**
  String get existingPlan;

  /// No description provided for @subscriptionEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get subscriptionEnded;

  /// No description provided for @subscriptionTransferable.
  ///
  /// In en, this message translates to:
  /// **'Transferable'**
  String get subscriptionTransferable;

  /// No description provided for @noInvoicesYet.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get noInvoicesYet;

  /// No description provided for @invoiceHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your payment history will appear here.'**
  String get invoiceHistorySubtitle;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number}'**
  String invoiceNumber(Object number);

  /// No description provided for @noClassesYet.
  ///
  /// In en, this message translates to:
  /// **'No classes yet'**
  String get noClassesYet;

  /// No description provided for @classInvoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Class purchase invoices will appear here.'**
  String get classInvoiceSubtitle;

  /// No description provided for @noRefundsYet.
  ///
  /// In en, this message translates to:
  /// **'No refunds yet'**
  String get noRefundsYet;

  /// No description provided for @noRefundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven’t requested any refunds.'**
  String get noRefundsSubtitle;

  /// No description provided for @noSubscriptionsYet.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions yet'**
  String get noSubscriptionsYet;

  /// No description provided for @noSubscriptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription invoices will show up here.'**
  String get noSubscriptionsSubtitle;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @invoicePdfNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No invoice PDF is available for this item.'**
  String get invoicePdfNotAvailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @membershipClassesRemainingOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} classes'**
  String membershipClassesRemainingOfTotal(int remaining, int total);

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @pleaseReviewTerms.
  ///
  /// In en, this message translates to:
  /// **'Please review and accept our terms'**
  String get pleaseReviewTerms;

  /// No description provided for @scrollLegalContentToContinue.
  ///
  /// In en, this message translates to:
  /// **'Scroll to the bottom of the text above to continue.'**
  String get scrollLegalContentToContinue;

  /// No description provided for @subscriptionAgreement.
  ///
  /// In en, this message translates to:
  /// **'Subscription Agreement'**
  String get subscriptionAgreement;

  /// No description provided for @subscriptionTermsText.
  ///
  /// In en, this message translates to:
  /// **'By subscribing to our Pilates membership, you agree to the following terms and conditions:\n\n1. Membership Terms\n- Your membership will automatically renew each month unless cancelled\n- Cancel anytime with 7 days notice before next billing cycle\n- No refunds for partial months\n\n2. Class Booking\n- Book classes 24 hours in advance\n- Cancel bookings minimum 2 hours before class\n- Late cancellations will deduct from your monthly credits\n- No-shows forfeit the class credit\n\n3. Branch Access\n- Your plan determines which branches you can access\n- Upgrade required to access additional locations...'**
  String get subscriptionTermsText;

  /// No description provided for @agreeToTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms & Conditions and Privacy Policy'**
  String get agreeToTermsAndConditions;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @safetyText.
  ///
  /// In en, this message translates to:
  /// **'Please read carefully.\n I understand that Pilates is physical exercise and has some risk of injury.\n I join the class voluntarily.\n I confirm the information I provided is true.\n I will tell The Pilates Studio if my health changes, if I get injured, or if I become pregnant.\n I understand Pilates instructors are not doctors and cannot diagnose or treat medical problems.\n I accept responsibility for my own safety during sessions.\n I understand that The Pilates Studio is not responsible for injuries that happen during normal exercise, except in cases of serious negligence.\n My information will stay private and used only to keep me safe.\n In an emergency, I allow staff to get medical help for me.\n I have read and understood everything above.\n I agree to follow instructions and exercise safely.'**
  String get safetyText;

  /// No description provided for @safetyConsent.
  ///
  /// In en, this message translates to:
  /// **'Safety & Consent'**
  String get safetyConsent;

  /// No description provided for @requiredInformation.
  ///
  /// In en, this message translates to:
  /// **'Required Information'**
  String get requiredInformation;

  /// No description provided for @requiredForLegalCompliance.
  ///
  /// In en, this message translates to:
  /// **'Required for legal compliance: This Information is mandatory for identity verification, fraud prevention, and refund processing.'**
  String get requiredForLegalCompliance;

  /// No description provided for @requiredForLegalComplianceShort.
  ///
  /// In en, this message translates to:
  /// **'Required for legal compliance'**
  String get requiredForLegalComplianceShort;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'In case of emergency during class'**
  String get emergencyContactSubtitle;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @selectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Select Relationship'**
  String get selectRelationship;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerification;

  /// No description provided for @idType.
  ///
  /// In en, this message translates to:
  /// **'ID Type'**
  String get idType;

  /// No description provided for @selectIdType.
  ///
  /// In en, this message translates to:
  /// **'Select ID Type'**
  String get selectIdType;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Date (Newest)'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Date (Oldest)'**
  String get oldest;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price (High to Low)'**
  String get priceHighToLow;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price (Low to High)'**
  String get priceLowToHigh;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @last3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3Months;

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @welcomeToPilates.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pilates!'**
  String get welcomeToPilates;

  /// No description provided for @membershipSetup.
  ///
  /// In en, this message translates to:
  /// **'Your membership is all set up'**
  String get membershipSetup;

  /// No description provided for @creditsReady.
  ///
  /// In en, this message translates to:
  /// **'Your first 12 credits are ready to use!'**
  String get creditsReady;

  /// No description provided for @bookFirstClass.
  ///
  /// In en, this message translates to:
  /// **'Book your first class and start your journey'**
  String get bookFirstClass;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring Classes'**
  String get startExploring;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice (PDF)'**
  String get downloadInvoice;

  /// No description provided for @invoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetails;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Date: January 23, 2026'**
  String get invoiceDate;

  /// No description provided for @premiumPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan (Monthly)'**
  String get premiumPlanMonthly;

  /// No description provided for @setupFee.
  ///
  /// In en, this message translates to:
  /// **'Setup Fee'**
  String get setupFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount (New Member)'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax (8%)'**
  String get tax;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @nextBillingDateText.
  ///
  /// In en, this message translates to:
  /// **'Next Billing Date'**
  String get nextBillingDateText;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @planDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
  String get planDetails;

  /// No description provided for @reviewYourSelection.
  ///
  /// In en, this message translates to:
  /// **'Review Your Selection'**
  String get reviewYourSelection;

  /// No description provided for @confirmPlanDetails.
  ///
  /// In en, this message translates to:
  /// **'Confirm your plan details'**
  String get confirmPlanDetails;

  /// No description provided for @classesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Classes per month'**
  String get classesPerMonth;

  /// No description provided for @validAt.
  ///
  /// In en, this message translates to:
  /// **'Valid at'**
  String get validAt;

  /// No description provided for @haveVoucherCode.
  ///
  /// In en, this message translates to:
  /// **'Have a voucher code?'**
  String get haveVoucherCode;

  /// No description provided for @enterVoucherCode.
  ///
  /// In en, this message translates to:
  /// **'Enter voucher code'**
  String get enterVoucherCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @voucherAppliedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Voucher applied successfully.'**
  String get voucherAppliedSuccess;

  /// No description provided for @planReviewPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get planReviewPendingPayment;

  /// No description provided for @cartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Cart date'**
  String get cartDateLabel;

  /// No description provided for @checkoutSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get checkoutSubtotal;

  /// No description provided for @checkoutVoucherDiscount.
  ///
  /// In en, this message translates to:
  /// **'Voucher discount'**
  String get checkoutVoucherDiscount;

  /// No description provided for @voucherAppliedSavings.
  ///
  /// In en, this message translates to:
  /// **'Voucher applied. You save {amount}.'**
  String voucherAppliedSavings(String amount);

  /// No description provided for @voucherAppliedDiscountMessage.
  ///
  /// In en, this message translates to:
  /// **'You got {amount} off. Voucher applied successfully.'**
  String voucherAppliedDiscountMessage(String amount);

  /// No description provided for @voucherCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Voucher code invalid'**
  String get voucherCodeInvalid;

  /// No description provided for @voucherEnterCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a voucher code to apply.'**
  String get voucherEnterCodeMessage;

  /// No description provided for @voucherCheckoutSessionMissing.
  ///
  /// In en, this message translates to:
  /// **'Checkout session is missing. Go back and try again.'**
  String get voucherCheckoutSessionMissing;

  /// No description provided for @acceptedPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Accepted methods of payment'**
  String get acceptedPaymentMethods;

  /// No description provided for @giftSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Gift Sent Successfully'**
  String get giftSentSuccessfully;

  /// No description provided for @giftProcessedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your gift subscription has been processed'**
  String get giftProcessedMessage;

  /// No description provided for @deliverySummary.
  ///
  /// In en, this message translates to:
  /// **'Delivery Summary'**
  String get deliverySummary;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientName;

  /// No description provided for @deliveryMethod.
  ///
  /// In en, this message translates to:
  /// **'Delivery Method'**
  String get deliveryMethod;

  /// No description provided for @deliveryMethodInstant.
  ///
  /// In en, this message translates to:
  /// **'Email (Instant)'**
  String get deliveryMethodInstant;

  /// No description provided for @giftStatus.
  ///
  /// In en, this message translates to:
  /// **'Gift Status'**
  String get giftStatus;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @redemptionEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'An email with redemption instructions has been sent to the recipient. They\'ll receive a unique code to activate their subscription.'**
  String get redemptionEmailMessage;

  /// No description provided for @startExploringClasses.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring Classes'**
  String get startExploringClasses;

  /// No description provided for @sendAnotherGift.
  ///
  /// In en, this message translates to:
  /// **'Send Another Gift'**
  String get sendAnotherGift;

  /// No description provided for @giftCard.
  ///
  /// In en, this message translates to:
  /// **'Gift Card'**
  String get giftCard;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @giftMessageLine1.
  ///
  /// In en, this message translates to:
  /// **'Hi Taha,\nHave a great month ahead.'**
  String get giftMessageLine1;

  /// No description provided for @giftMessageLine2.
  ///
  /// In en, this message translates to:
  /// **'Happy New Year 2027'**
  String get giftMessageLine2;

  /// No description provided for @giftCardRecipientGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name},'**
  String giftCardRecipientGreeting(String name);

  /// No description provided for @giftCardMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your personal message will appear here.'**
  String get giftCardMessagePlaceholder;

  /// No description provided for @recipientDetails.
  ///
  /// In en, this message translates to:
  /// **'Recipient Details'**
  String get recipientDetails;

  /// No description provided for @recipientNameHint.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientNameHint;

  /// No description provided for @recipientEmail.
  ///
  /// In en, this message translates to:
  /// **'Recipient Email'**
  String get recipientEmail;

  /// No description provided for @recipientEmailHintGmail.
  ///
  /// In en, this message translates to:
  /// **'email@gmail.com'**
  String get recipientEmailHintGmail;

  /// No description provided for @recipientPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient phone number'**
  String get recipientPhoneOptional;

  /// No description provided for @giftRecipientValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required recipient details.'**
  String get giftRecipientValidationError;

  /// No description provided for @giftCheckoutSessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Gift delivery needs an active checkout session. Continue from checkout after creating a cart, or pass the session id into this screen.'**
  String get giftCheckoutSessionRequired;

  /// No description provided for @giftCheckoutNotGiftSession.
  ///
  /// In en, this message translates to:
  /// **'This checkout is not a gift cart. Create the session with checkout/start using \"isGift\": true, then call add gift details with that checkout id.'**
  String get giftCheckoutNotGiftSession;

  /// No description provided for @checkoutPaymentAlreadyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment for this checkout is already completed. Continuing.'**
  String get checkoutPaymentAlreadyCompleted;

  /// No description provided for @healthAnswerExplainHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly explain your answer (required when you select Yes).'**
  String get healthAnswerExplainHint;

  /// No description provided for @pleaseSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'Please select a plan.'**
  String get pleaseSelectPlan;

  /// No description provided for @giftValidationRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Enter the recipient\'s name (at least 2 characters).'**
  String get giftValidationRecipientName;

  /// No description provided for @giftValidationRecipientEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the recipient\'s email address.'**
  String get giftValidationRecipientEmail;

  /// No description provided for @giftValidationRecipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter the recipient\'s phone number.'**
  String get giftValidationRecipientPhone;

  /// No description provided for @giftValidationScheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a delivery date or choose instant delivery.'**
  String get giftValidationScheduleDate;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'XXXXXXXXXXX'**
  String get phoneHint;

  /// No description provided for @deliveryOptions.
  ///
  /// In en, this message translates to:
  /// **'Delivery Options'**
  String get deliveryOptions;

  /// No description provided for @instantDelivery.
  ///
  /// In en, this message translates to:
  /// **'Instant Delivery'**
  String get instantDelivery;

  /// No description provided for @scheduledDelivery1.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Delivery'**
  String get scheduledDelivery1;

  /// No description provided for @personalMessageOptional.
  ///
  /// In en, this message translates to:
  /// **'Personal Message (Optional)'**
  String get personalMessageOptional;

  /// No description provided for @personalMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Hi Taha,\n\nHave a great month ahead. Happy New Year 2027'**
  String get personalMessageHint;

  /// No description provided for @charactersCount.
  ///
  /// In en, this message translates to:
  /// **'40/128 characters'**
  String get charactersCount;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'Use device theme'**
  String get systemTheme;

  /// No description provided for @switchTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchTheme;

  /// No description provided for @myActivity.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get myActivity;

  /// No description provided for @progressDashboard.
  ///
  /// In en, this message translates to:
  /// **'Progress Dashboard'**
  String get progressDashboard;

  /// No description provided for @progressDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your fitness journey'**
  String get progressDashboardSubtitle;

  /// No description provided for @myBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View bookings history'**
  String get myBookingsSubtitle;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @challengesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join active challenges'**
  String get challengesSubtitle;

  /// No description provided for @rewardsCatalog.
  ///
  /// In en, this message translates to:
  /// **'Rewards Catalog'**
  String get rewardsCatalog;

  /// No description provided for @rewardsCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Redeem your points'**
  String get rewardsCatalogSubtitle;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your badges'**
  String get achievementsSubtitle;

  /// No description provided for @loyaltyRewardRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reward rules'**
  String get loyaltyRewardRulesTitle;

  /// No description provided for @redeemGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Redeem Gift Card'**
  String get redeemGiftCard;

  /// No description provided for @redeemGiftCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter code to redeem card'**
  String get redeemGiftCardSubtitle;

  /// No description provided for @referralProgram.
  ///
  /// In en, this message translates to:
  /// **'Referral Program'**
  String get referralProgram;

  /// No description provided for @referralProgramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends & earn'**
  String get referralProgramSubtitle;

  /// No description provided for @helpAbout.
  ///
  /// In en, this message translates to:
  /// **'Help & About'**
  String get helpAbout;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and Contact Us'**
  String get helpSupportSubtitle;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @termsConditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Legal terms of service'**
  String get termsConditionsSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @browseTrainers.
  ///
  /// In en, this message translates to:
  /// **'Browse Trainers'**
  String get browseTrainers;

  /// No description provided for @meetOurTrainers.
  ///
  /// In en, this message translates to:
  /// **'Meet our trainers'**
  String get meetOurTrainers;

  /// No description provided for @changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get changeProfilePicture;

  /// No description provided for @recipientEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get recipientEmailHint;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone Number'**
  String get emergencyContactPhoneNumber;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @spouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouse;

  /// No description provided for @sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get sibling;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @driverLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver License'**
  String get driverLicense;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetails;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  String get allNotifications;

  /// No description provided for @classNotifications.
  ///
  /// In en, this message translates to:
  /// **'Class Notifications'**
  String get classNotifications;

  /// No description provided for @beforeClassStarts.
  ///
  /// In en, this message translates to:
  /// **'Before Class Starts'**
  String get beforeClassStarts;

  /// No description provided for @beforeClassStartsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified {minutes} min before'**
  String beforeClassStartsSubtitle(int minutes);

  /// No description provided for @dayBeforeReminder.
  ///
  /// In en, this message translates to:
  /// **'Day Before Reminder'**
  String get dayBeforeReminder;

  /// No description provided for @dayBeforeReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder 24 hours before'**
  String get dayBeforeReminderSubtitle;

  /// No description provided for @subscriptionBilling.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Billing'**
  String get subscriptionBilling;

  /// No description provided for @paymentConfirmations.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmations'**
  String get paymentConfirmations;

  /// No description provided for @paymentConfirmationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Successful transactions'**
  String get paymentConfirmationsSubtitle;

  /// No description provided for @renewalReminders.
  ///
  /// In en, this message translates to:
  /// **'Renewal Reminders'**
  String get renewalReminders;

  /// No description provided for @renewalRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'3 days before renewal'**
  String get renewalRemindersSubtitle;

  /// No description provided for @marketingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Marketing & Updates'**
  String get marketingUpdates;

  /// No description provided for @promotionsOffers.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Offers'**
  String get promotionsOffers;

  /// No description provided for @promotionsOffersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Special deals and discounts'**
  String get promotionsOffersSubtitle;

  /// No description provided for @appUpdates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// No description provided for @appUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New features and improvements'**
  String get appUpdatesSubtitle;

  /// No description provided for @challengesRewards.
  ///
  /// In en, this message translates to:
  /// **'Challenges & Rewards'**
  String get challengesRewards;

  /// No description provided for @newChallenges.
  ///
  /// In en, this message translates to:
  /// **'New Challenges'**
  String get newChallenges;

  /// No description provided for @newChallengesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When new challenges available'**
  String get newChallengesSubtitle;

  /// No description provided for @redeemGiftCardTxt.
  ///
  /// In en, this message translates to:
  /// **'Redeem Gift Card'**
  String get redeemGiftCardTxt;

  /// No description provided for @enterGiftCardCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Gift Card Code'**
  String get enterGiftCardCode;

  /// No description provided for @enterRedeemCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Redeem Code'**
  String get enterRedeemCode;

  /// No description provided for @invalidGiftCardCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid gift card code'**
  String get invalidGiftCardCode;

  /// No description provided for @redeemCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your gift card code'**
  String get redeemCodeRequired;

  /// No description provided for @redeemGift.
  ///
  /// In en, this message translates to:
  /// **'Redeem Gift'**
  String get redeemGift;

  /// No description provided for @giftReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'You received a gift card'**
  String get giftReceivedTitle;

  /// No description provided for @viewGift.
  ///
  /// In en, this message translates to:
  /// **'View Gift'**
  String get viewGift;

  /// No description provided for @giftRedeemedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gift card redeemed successfully'**
  String get giftRedeemedSuccess;

  /// No description provided for @receivedGiftTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve Received a Gift!'**
  String get receivedGiftTitle;

  /// No description provided for @receivedGiftSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ayesha sent you a Pilates membership'**
  String get receivedGiftSubtitle;

  /// No description provided for @redeemYourGift.
  ///
  /// In en, this message translates to:
  /// **'Redeem Your Gift'**
  String get redeemYourGift;

  /// No description provided for @yourGiftIncludes.
  ///
  /// In en, this message translates to:
  /// **'Your Gift Includes'**
  String get yourGiftIncludes;

  /// No description provided for @redemptionCode.
  ///
  /// In en, this message translates to:
  /// **'Redemption Code'**
  String get redemptionCode;

  /// No description provided for @birthdayMessage.
  ///
  /// In en, this message translates to:
  /// **'Happy Birthday Sarah! I thought you\'d love trying Pilates. Looking forward to taking classes together! 💪'**
  String get birthdayMessage;

  /// No description provided for @giftSender.
  ///
  /// In en, this message translates to:
  /// **'— Ayesha'**
  String get giftSender;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'By downloading, installing, or using the app, you agree to comply with these Terms of Use and our Privacy Policy. If you do not agree with any part of these terms, please do not use the app. You must be at least 13 years old (or the legal age in your jurisdiction) to use this app. By using the app, you confirm that you meet the minimum age requirement.'**
  String get termsIntro;

  /// No description provided for @termsMedicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Our content is for general wellness and informational purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider if you have any health concerns.'**
  String get termsMedicalDisclaimer;

  /// No description provided for @termsAccountResponsibility.
  ///
  /// In en, this message translates to:
  /// **'If you create an account, you are responsible for maintaining its confidentiality. Notify us immediately if you suspect unauthorized access or use.'**
  String get termsAccountResponsibility;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'At our app, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and protect your data when you use our app. By accessing or using the app, you agree to the practices described in this policy.'**
  String get privacyIntro;

  /// No description provided for @privacyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyInfoTitle;

  /// No description provided for @privacyInfoBody.
  ///
  /// In en, this message translates to:
  /// **'We may collect personal details such as your name, email address, phone number, usage data, and device information to improve your experience and provide our services effectively.'**
  String get privacyInfoBody;

  /// No description provided for @privacyUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyUsageTitle;

  /// No description provided for @privacyUsageBody.
  ///
  /// In en, this message translates to:
  /// **'Your information is used to provide and improve the app, personalize your experience, communicate with you, process transactions, and ensure the security of our services.'**
  String get privacyUsageBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing and Disclosure'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information. We may share data with trusted service providers, legal authorities when required, or in cases necessary to protect our rights and users.'**
  String get privacySharingBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Data Protection Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information. You may also request data portability or withdraw consent where applicable by contacting our support team.'**
  String get privacyRightsBody;

  /// No description provided for @relationshipParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get relationshipParent;

  /// No description provided for @relationshipSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get relationshipSpouse;

  /// No description provided for @relationshipSibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get relationshipSibling;

  /// No description provided for @relationshipFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get relationshipFriend;

  /// No description provided for @relationshipOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get relationshipOther;

  /// No description provided for @idTypeNationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get idTypeNationalId;

  /// No description provided for @idTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get idTypePassport;

  /// No description provided for @idTypeDriverLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver License'**
  String get idTypeDriverLicense;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// No description provided for @buildStrength.
  ///
  /// In en, this message translates to:
  /// **'Build Strength'**
  String get buildStrength;

  /// No description provided for @buildStrengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Power, reformer, core work'**
  String get buildStrengthDesc;

  /// No description provided for @findMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Find Mindfulness'**
  String get findMindfulness;

  /// No description provided for @findMindfulnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Flow, meditation, calm'**
  String get findMindfulnessDesc;

  /// No description provided for @improveFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Improve Flexibility'**
  String get improveFlexibility;

  /// No description provided for @improveFlexibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Stretch, mobility, range'**
  String get improveFlexibilityDesc;

  /// No description provided for @generalFitness.
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get generalFitness;

  /// No description provided for @generalFitnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced, all-around wellness'**
  String get generalFitnessDesc;

  /// No description provided for @monthlyTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Target'**
  String get monthlyTarget;

  /// No description provided for @pilatesPrimaryFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to Pilates? Select your primary focus'**
  String get pilatesPrimaryFocusTitle;

  /// No description provided for @yourJourney_title.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get yourJourney_title;

  /// No description provided for @yourJourney_achievement_content.
  ///
  /// In en, this message translates to:
  /// **'7 more to discover your path'**
  String get yourJourney_achievement_content;

  /// No description provided for @yourJourney_achievements_earned.
  ///
  /// In en, this message translates to:
  /// **'Achievements Earned'**
  String get yourJourney_achievements_earned;

  /// No description provided for @yourJourney_on_your_path.
  ///
  /// In en, this message translates to:
  /// **'On Your Path'**
  String get yourJourney_on_your_path;

  /// No description provided for @yourJourney_consistency_title.
  ///
  /// In en, this message translates to:
  /// **'Consistency Flow'**
  String get yourJourney_consistency_title;

  /// No description provided for @yourJourney_consistency_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Badge'**
  String get yourJourney_consistency_subtitle;

  /// No description provided for @yourJourney_consistency_content.
  ///
  /// In en, this message translates to:
  /// **'Attended classes 12 days in a row, building a sustainable practice'**
  String get yourJourney_consistency_content;

  /// No description provided for @yourJourney_consistency_date.
  ///
  /// In en, this message translates to:
  /// **'Earned January 26, 2026'**
  String get yourJourney_consistency_date;

  /// No description provided for @yourJourney_foundation_title.
  ///
  /// In en, this message translates to:
  /// **'Foundation Builder'**
  String get yourJourney_foundation_title;

  /// No description provided for @yourJourney_foundation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone Badge'**
  String get yourJourney_foundation_subtitle;

  /// No description provided for @yourJourney_foundation_content.
  ///
  /// In en, this message translates to:
  /// **'Reached your first 10 classes, establishing a strong foundation'**
  String get yourJourney_foundation_content;

  /// No description provided for @yourJourney_foundation_date.
  ///
  /// In en, this message translates to:
  /// **'Earned January 20, 2026'**
  String get yourJourney_foundation_date;

  /// No description provided for @yourJourney_monthly_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly Dedication'**
  String get yourJourney_monthly_title;

  /// No description provided for @yourJourney_monthly_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone Badge'**
  String get yourJourney_monthly_subtitle;

  /// No description provided for @yourJourney_monthly_content.
  ///
  /// In en, this message translates to:
  /// **'Complete 16 classes in a single month'**
  String get yourJourney_monthly_content;

  /// No description provided for @yourJourney_monthly_date.
  ///
  /// In en, this message translates to:
  /// **'4 classes remaining'**
  String get yourJourney_monthly_date;

  /// No description provided for @yourJourney_community_title.
  ///
  /// In en, this message translates to:
  /// **'Community Spirit'**
  String get yourJourney_community_title;

  /// No description provided for @yourJourney_community_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Special Badge'**
  String get yourJourney_community_subtitle;

  /// No description provided for @yourJourney_community_content.
  ///
  /// In en, this message translates to:
  /// **'Attend 10 group sessions, connecting with the community'**
  String get yourJourney_community_content;

  /// No description provided for @yourJourney_community_date.
  ///
  /// In en, this message translates to:
  /// **'4 classes remaining'**
  String get yourJourney_community_date;

  /// No description provided for @yourJourney_your_progress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourJourney_your_progress;

  /// No description provided for @yourJourney_progress_count.
  ///
  /// In en, this message translates to:
  /// **'12 of 16 classes'**
  String get yourJourney_progress_count;

  /// No description provided for @yourJourney_points.
  ///
  /// In en, this message translates to:
  /// **'+50 pts'**
  String get yourJourney_points;

  /// No description provided for @achievement_your_achievements.
  ///
  /// In en, this message translates to:
  /// **'Your Achievements'**
  String get achievement_your_achievements;

  /// No description provided for @achievement_content.
  ///
  /// In en, this message translates to:
  /// **'Building your practice journey'**
  String get achievement_content;

  /// No description provided for @achievement_consistency_title.
  ///
  /// In en, this message translates to:
  /// **'Consistency Flow'**
  String get achievement_consistency_title;

  /// No description provided for @achievement_consistency_subtitle.
  ///
  /// In en, this message translates to:
  /// **'12 days in a row'**
  String get achievement_consistency_subtitle;

  /// No description provided for @achievement_foundation_title.
  ///
  /// In en, this message translates to:
  /// **'Foundation Builder'**
  String get achievement_foundation_title;

  /// No description provided for @achievement_foundation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Classes 12 days in a row'**
  String get achievement_foundation_subtitle;

  /// No description provided for @achievement_monthly_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly Dedication'**
  String get achievement_monthly_title;

  /// No description provided for @achievement_monthly_subtitle.
  ///
  /// In en, this message translates to:
  /// **'12 / 16 classes'**
  String get achievement_monthly_subtitle;

  /// No description provided for @achievement_view_all_button.
  ///
  /// In en, this message translates to:
  /// **'View All Achievements'**
  String get achievement_view_all_button;

  /// No description provided for @edit_goal_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Goal'**
  String get edit_goal_title;

  /// No description provided for @edit_goal_current_goal.
  ///
  /// In en, this message translates to:
  /// **'Current Goal'**
  String get edit_goal_current_goal;

  /// No description provided for @edit_goal_intermediate_level.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Level'**
  String get edit_goal_intermediate_level;

  /// No description provided for @edit_goal_choose_focus.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Focus'**
  String get edit_goal_choose_focus;

  /// No description provided for @edit_goal_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get edit_goal_save_changes;

  /// No description provided for @edit_goal_tip_label.
  ///
  /// In en, this message translates to:
  /// **'Tip: '**
  String get edit_goal_tip_label;

  /// No description provided for @edit_goal_tip_content.
  ///
  /// In en, this message translates to:
  /// **'Your goal personalizes your progress tracking. You can change it anytime to match your evolving fitness journey.'**
  String get edit_goal_tip_content;

  /// No description provided for @edit_goal_tap_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap the edit button to change your goal anytime'**
  String get edit_goal_tap_hint;

  /// No description provided for @goal_progress_title.
  ///
  /// In en, this message translates to:
  /// **'January Goal Progress'**
  String get goal_progress_title;

  /// No description provided for @goal_progress_percentage.
  ///
  /// In en, this message translates to:
  /// **'75%'**
  String get goal_progress_percentage;

  /// No description provided for @goal_progress_complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get goal_progress_complete;

  /// No description provided for @goal_progress_sessions.
  ///
  /// In en, this message translates to:
  /// **'12 of 16 mindful sessions'**
  String get goal_progress_sessions;

  /// No description provided for @goal_progress_remaining.
  ///
  /// In en, this message translates to:
  /// **'4 more to reach your goal'**
  String get goal_progress_remaining;

  /// No description provided for @progress_tab_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get progress_tab_overview;

  /// No description provided for @progress_tab_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get progress_tab_history;

  /// No description provided for @progress_tab_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get progress_tab_achievements;

  /// No description provided for @weekly_activity_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weekly_activity_title;

  /// No description provided for @weekly_activity_minutes.
  ///
  /// In en, this message translates to:
  /// **'%sm'**
  String get weekly_activity_minutes;

  /// No description provided for @weekly_activity_mindful_movement.
  ///
  /// In en, this message translates to:
  /// **'Mindful Movement: '**
  String get weekly_activity_mindful_movement;

  /// No description provided for @weekly_activity_summary.
  ///
  /// In en, this message translates to:
  /// **'280 minutes • 6 sessions'**
  String get weekly_activity_summary;

  /// No description provided for @weekly_day_monday.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekly_day_monday;

  /// No description provided for @weekly_day_tuesday.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekly_day_tuesday;

  /// No description provided for @weekly_day_wednesday.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekly_day_wednesday;

  /// No description provided for @weekly_day_thursday.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekly_day_thursday;

  /// No description provided for @weekly_day_friday.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekly_day_friday;

  /// No description provided for @weekly_day_saturday.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekly_day_saturday;

  /// No description provided for @weekly_day_sunday.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekly_day_sunday;

  /// No description provided for @mind_practice_title.
  ///
  /// In en, this message translates to:
  /// **'Your Mindful Practice'**
  String get mind_practice_title;

  /// No description provided for @mind_practice_mindful_movement.
  ///
  /// In en, this message translates to:
  /// **'Mindful Movement'**
  String get mind_practice_mindful_movement;

  /// No description provided for @mind_practice_morning_sessions.
  ///
  /// In en, this message translates to:
  /// **'Morning Sessions'**
  String get mind_practice_morning_sessions;

  /// No description provided for @mind_practice_flow_instructors.
  ///
  /// In en, this message translates to:
  /// **'Flow Instructors'**
  String get mind_practice_flow_instructors;

  /// No description provided for @mind_practice_inner_peace.
  ///
  /// In en, this message translates to:
  /// **'Inner Peace'**
  String get mind_practice_inner_peace;

  /// No description provided for @mind_practice_mindful_value.
  ///
  /// In en, this message translates to:
  /// **'8.5 hr'**
  String get mind_practice_mindful_value;

  /// No description provided for @mind_practice_morning_value.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get mind_practice_morning_value;

  /// No description provided for @mind_practice_instructors_value.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get mind_practice_instructors_value;

  /// No description provided for @mind_practice_peace_value.
  ///
  /// In en, this message translates to:
  /// **'+25%'**
  String get mind_practice_peace_value;

  /// No description provided for @session_history_title.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get session_history_title;

  /// No description provided for @session_history_classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get session_history_classes;

  /// No description provided for @session_history_total_time.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get session_history_total_time;

  /// No description provided for @session_history_points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get session_history_points;

  /// No description provided for @session_history_all_time.
  ///
  /// In en, this message translates to:
  /// **'All Time History'**
  String get session_history_all_time;

  /// No description provided for @session_history_this_month.
  ///
  /// In en, this message translates to:
  /// **'January 2026'**
  String get session_history_this_month;

  /// No description provided for @session_history_last_30_days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get session_history_last_30_days;

  /// No description provided for @session_history_classes_value.
  ///
  /// In en, this message translates to:
  /// **'42'**
  String get session_history_classes_value;

  /// No description provided for @session_history_time_value.
  ///
  /// In en, this message translates to:
  /// **'31h'**
  String get session_history_time_value;

  /// No description provided for @session_history_points_value.
  ///
  /// In en, this message translates to:
  /// **'1050'**
  String get session_history_points_value;

  /// No description provided for @session_history_this_month_txt.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get session_history_this_month_txt;

  /// No description provided for @session_card_class_name.
  ///
  /// In en, this message translates to:
  /// **'Core Strength Flow'**
  String get session_card_class_name;

  /// No description provided for @session_card_instructor.
  ///
  /// In en, this message translates to:
  /// **'with Sarah Chen'**
  String get session_card_instructor;

  /// No description provided for @session_card_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get session_card_status_completed;

  /// No description provided for @session_card_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get session_card_today;

  /// No description provided for @session_card_duration.
  ///
  /// In en, this message translates to:
  /// **'45 Min'**
  String get session_card_duration;

  /// No description provided for @session_card_points.
  ///
  /// In en, this message translates to:
  /// **'+25 pts'**
  String get session_card_points;

  /// No description provided for @session_history_view_full.
  ///
  /// In en, this message translates to:
  /// **'View Full History'**
  String get session_history_view_full;

  /// No description provided for @progress_tracking_title.
  ///
  /// In en, this message translates to:
  /// **'Progress & Tracking'**
  String get progress_tracking_title;

  /// No description provided for @february_streak.
  ///
  /// In en, this message translates to:
  /// **'February Streak'**
  String get february_streak;

  /// No description provided for @studio_legend.
  ///
  /// In en, this message translates to:
  /// **'Studio Legend'**
  String get studio_legend;

  /// No description provided for @first_step.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get first_step;

  /// No description provided for @early_bird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get early_bird;

  /// No description provided for @lotus_blossom.
  ///
  /// In en, this message translates to:
  /// **'Lotus Blossom'**
  String get lotus_blossom;

  /// No description provided for @core_strength.
  ///
  /// In en, this message translates to:
  /// **'Core Strength'**
  String get core_strength;

  /// No description provided for @week_warrior.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get week_warrior;

  /// No description provided for @balance_master.
  ///
  /// In en, this message translates to:
  /// **'Balance Master'**
  String get balance_master;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @badge_complete_classes.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} classes in {month}'**
  String badge_complete_classes(Object count, Object month);

  /// No description provided for @badge_earned_on.
  ///
  /// In en, this message translates to:
  /// **'Earned on {date}'**
  String badge_earned_on(Object date);

  /// No description provided for @share_badge.
  ///
  /// In en, this message translates to:
  /// **'Share This Badge'**
  String get share_badge;

  /// No description provided for @badge_bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get badge_bronze;

  /// No description provided for @badge_silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get badge_silver;

  /// No description provided for @badge_gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get badge_gold;

  /// No description provided for @badge_collection.
  ///
  /// In en, this message translates to:
  /// **'Badge Collection'**
  String get badge_collection;

  /// No description provided for @challenge_detail.
  ///
  /// In en, this message translates to:
  /// **'Challenge Detail'**
  String get challenge_detail;

  /// No description provided for @twenty_classes_month.
  ///
  /// In en, this message translates to:
  /// **'20 Classes This Month'**
  String get twenty_classes_month;

  /// No description provided for @complete_classes_feb.
  ///
  /// In en, this message translates to:
  /// **'Complete 20 classes in February'**
  String get complete_classes_feb;

  /// No description provided for @your_progress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get your_progress;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @classes_completed.
  ///
  /// In en, this message translates to:
  /// **'classes completed'**
  String get classes_completed;

  /// No description provided for @percent_complete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String percent_complete(Object percent);

  /// No description provided for @more_classes_to_go.
  ///
  /// In en, this message translates to:
  /// **'{count} more classes to go'**
  String more_classes_to_go(Object count);

  /// No description provided for @rank_number.
  ///
  /// In en, this message translates to:
  /// **'Rank #{rank}'**
  String rank_number(Object rank);

  /// No description provided for @days_left.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String days_left(Object days);

  /// No description provided for @points_short.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String points_short(int points);

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String points(Object points);

  /// No description provided for @benefit_gold_badge.
  ///
  /// In en, this message translates to:
  /// **'Gold Badge'**
  String get benefit_gold_badge;

  /// No description provided for @benefit_feb_champion.
  ///
  /// In en, this message translates to:
  /// **'February Champion'**
  String get benefit_feb_champion;

  /// No description provided for @benefit_bonus_points.
  ///
  /// In en, this message translates to:
  /// **'{points} Bonus Points'**
  String benefit_bonus_points(Object points);

  /// No description provided for @benefit_redeem_rewards.
  ///
  /// In en, this message translates to:
  /// **'Redeem for rewards'**
  String get benefit_redeem_rewards;

  /// No description provided for @benefit_discount.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Subscription Discount'**
  String benefit_discount(Object percent);

  /// No description provided for @benefit_next_billing.
  ///
  /// In en, this message translates to:
  /// **'Next month\'s billing'**
  String get benefit_next_billing;

  /// No description provided for @days_only.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String days_only(Object days);

  /// No description provided for @people_joined.
  ///
  /// In en, this message translates to:
  /// **'{count} joined'**
  String people_joined(Object count);

  /// No description provided for @join_challenge.
  ///
  /// In en, this message translates to:
  /// **'Join Challenge'**
  String get join_challenge;

  /// No description provided for @core_strength_challenge.
  ///
  /// In en, this message translates to:
  /// **'Core Strength Challenge'**
  String get core_strength_challenge;

  /// No description provided for @core_strength_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Master {count} core-focused classes'**
  String core_strength_subtitle(Object count);

  /// No description provided for @challenge_details.
  ///
  /// In en, this message translates to:
  /// **'Challenge Details'**
  String get challenge_details;

  /// No description provided for @challenge_description.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} classes before the end of {month}. Track your progress daily and compete with other members!'**
  String challenge_description(Object count, Object month);

  /// No description provided for @what_you_will_earn.
  ///
  /// In en, this message translates to:
  /// **'What You’ll Earn'**
  String get what_you_will_earn;

  /// No description provided for @my_active_challenges.
  ///
  /// In en, this message translates to:
  /// **'My Active Challenges'**
  String get my_active_challenges;

  /// No description provided for @new_challenges.
  ///
  /// In en, this message translates to:
  /// **'New Challenges'**
  String get new_challenges;

  /// No description provided for @challenge_20_classes_title.
  ///
  /// In en, this message translates to:
  /// **'20 Classes This Month'**
  String get challenge_20_classes_title;

  /// No description provided for @challenge_20_classes_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed {count} classes in {month}'**
  String challenge_20_classes_subtitle(Object count, Object month);

  /// No description provided for @challenge_streak_title.
  ///
  /// In en, this message translates to:
  /// **'7-Day Streak Builder'**
  String get challenge_streak_title;

  /// No description provided for @challenge_streak_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Attend class {days} days in a row'**
  String challenge_streak_subtitle(Object days);

  /// No description provided for @challenge_core_title.
  ///
  /// In en, this message translates to:
  /// **'Core Strength Challenge'**
  String get challenge_core_title;

  /// No description provided for @challenge_core_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Master {count} core-focused classes'**
  String challenge_core_subtitle(Object count);

  /// No description provided for @challenge_spring_title.
  ///
  /// In en, this message translates to:
  /// **'Spring Into Fitness'**
  String get challenge_spring_title;

  /// No description provided for @challenge_spring_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} classes this season'**
  String challenge_spring_subtitle(Object count);

  /// No description provided for @redeem_reward.
  ///
  /// In en, this message translates to:
  /// **'Redeem Reward'**
  String get redeem_reward;

  /// No description provided for @redemption_details.
  ///
  /// In en, this message translates to:
  /// **'Redemption Details'**
  String get redemption_details;

  /// No description provided for @confirm_redemption.
  ///
  /// In en, this message translates to:
  /// **'Confirm Redemption'**
  String get confirm_redemption;

  /// No description provided for @priority_booking_week.
  ///
  /// In en, this message translates to:
  /// **'Priority Booking - Week'**
  String get priority_booking_week;

  /// No description provided for @priority_booking_desc.
  ///
  /// In en, this message translates to:
  /// **'Book classes 48hrs early for 7 days'**
  String get priority_booking_desc;

  /// No description provided for @current_balance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get current_balance;

  /// No description provided for @this_reward.
  ///
  /// In en, this message translates to:
  /// **'This Reward'**
  String get this_reward;

  /// No description provided for @after_redemption.
  ///
  /// In en, this message translates to:
  /// **'After Redemption'**
  String get after_redemption;

  /// No description provided for @redeem_warning.
  ///
  /// In en, this message translates to:
  /// **'By redeeming this reward, you agree that points cannot be refunded. Rewards are non-transferable and subject to availability.'**
  String get redeem_warning;

  /// No description provided for @rewards_history.
  ///
  /// In en, this message translates to:
  /// **'Rewards History'**
  String get rewards_history;

  /// No description provided for @studio_water_bottle.
  ///
  /// In en, this message translates to:
  /// **'Studio Water Bottle'**
  String get studio_water_bottle;

  /// No description provided for @free_class_pass.
  ///
  /// In en, this message translates to:
  /// **'Free Class Pass'**
  String get free_class_pass;

  /// No description provided for @redeemed_on.
  ///
  /// In en, this message translates to:
  /// **'Redeemed {date}'**
  String redeemed_on(Object date);

  /// No description provided for @your_balance.
  ///
  /// In en, this message translates to:
  /// **'Your Balance'**
  String get your_balance;

  /// No description provided for @current_tier.
  ///
  /// In en, this message translates to:
  /// **'Current Tier'**
  String get current_tier;

  /// No description provided for @silver_member.
  ///
  /// In en, this message translates to:
  /// **'Silver Member'**
  String get silver_member;

  /// No description provided for @progress_to_gold.
  ///
  /// In en, this message translates to:
  /// **'Progress to Gold'**
  String get progress_to_gold;

  /// No description provided for @points_to_go.
  ///
  /// In en, this message translates to:
  /// **'{points} pts to go'**
  String points_to_go(Object points);

  /// No description provided for @your_silver_benefits.
  ///
  /// In en, this message translates to:
  /// **'Your Silver Benefits'**
  String get your_silver_benefits;

  /// No description provided for @showing_rewards_from.
  ///
  /// In en, this message translates to:
  /// **'Showing rewards from'**
  String get showing_rewards_from;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @available_rewards.
  ///
  /// In en, this message translates to:
  /// **'Available Rewards'**
  String get available_rewards;

  /// No description provided for @exclusive_workshop.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Workshop Access'**
  String get exclusive_workshop;

  /// No description provided for @exclusive_workshop_desc.
  ///
  /// In en, this message translates to:
  /// **'Advanced techniques masterclass'**
  String get exclusive_workshop_desc;

  /// No description provided for @guest_pass_3.
  ///
  /// In en, this message translates to:
  /// **'Guest Pass (3-Pack)'**
  String get guest_pass_3;

  /// No description provided for @guest_pass_desc.
  ///
  /// In en, this message translates to:
  /// **'Bring friends to 3 classes'**
  String get guest_pass_desc;

  /// No description provided for @meditation_session.
  ///
  /// In en, this message translates to:
  /// **'Meditation Session'**
  String get meditation_session;

  /// No description provided for @meditation_session_desc.
  ///
  /// In en, this message translates to:
  /// **'Private 30-min guided meditation'**
  String get meditation_session_desc;

  /// No description provided for @experiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiences;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @redeem_how_to_collect.
  ///
  /// In en, this message translates to:
  /// **'How to Collect'**
  String get redeem_how_to_collect;

  /// No description provided for @redeem_collect_desc.
  ///
  /// In en, this message translates to:
  /// **'Pick up your water bottle at the front desk during your next visit. Show this confirmation screen.'**
  String get redeem_collect_desc;

  /// No description provided for @redeem_valid_for.
  ///
  /// In en, this message translates to:
  /// **'Valid For'**
  String get redeem_valid_for;

  /// No description provided for @redeem_valid_desc.
  ///
  /// In en, this message translates to:
  /// **'This reward is valid for 30 days from redemption date.'**
  String get redeem_valid_desc;

  /// No description provided for @redeem_available_at.
  ///
  /// In en, this message translates to:
  /// **'Available At'**
  String get redeem_available_at;

  /// No description provided for @redeem_available_desc.
  ///
  /// In en, this message translates to:
  /// **'All branch locations'**
  String get redeem_available_desc;

  /// No description provided for @reward_redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get reward_redeem;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @select_branch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get select_branch;

  /// No description provided for @featurePriorityBookingDesc.
  ///
  /// In en, this message translates to:
  /// **'Book classes 24hrs in advance'**
  String get featurePriorityBookingDesc;

  /// No description provided for @featureMerchDiscount.
  ///
  /// In en, this message translates to:
  /// **'Merch Discount'**
  String get featureMerchDiscount;

  /// No description provided for @featureMerchDiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'10% off all studio merchandise'**
  String get featureMerchDiscountDesc;

  /// No description provided for @featureGuestPass.
  ///
  /// In en, this message translates to:
  /// **'Monthly Guest Pass'**
  String get featureGuestPass;

  /// No description provided for @featureGuestPassDesc.
  ///
  /// In en, this message translates to:
  /// **'Bring a friend once per month'**
  String get featureGuestPassDesc;

  /// No description provided for @viewAllTiers.
  ///
  /// In en, this message translates to:
  /// **'View All Tiers'**
  String get viewAllTiers;

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get yourReferralCode;

  /// No description provided for @shareCodeWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share this code with friends'**
  String get shareCodeWithFriends;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @shareViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareViaWhatsapp;

  /// No description provided for @inviteDirectly.
  ///
  /// In en, this message translates to:
  /// **'Invite Directly'**
  String get inviteDirectly;

  /// No description provided for @sendPersonalInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send a personal invitation to your friends'**
  String get sendPersonalInvitation;

  /// No description provided for @friendsName.
  ///
  /// In en, this message translates to:
  /// **'Friend’s Name'**
  String get friendsName;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get sendInvitation;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @shareYourCode.
  ///
  /// In en, this message translates to:
  /// **'Share Your Code'**
  String get shareYourCode;

  /// No description provided for @shareYourCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Send your unique referral code to friends and family'**
  String get shareYourCodeDesc;

  /// No description provided for @theySignUp.
  ///
  /// In en, this message translates to:
  /// **'They Sign Up'**
  String get theySignUp;

  /// No description provided for @theySignUpDesc.
  ///
  /// In en, this message translates to:
  /// **'Friend uses your code when subscribing to any plan'**
  String get theySignUpDesc;

  /// No description provided for @youBothGetRewards.
  ///
  /// In en, this message translates to:
  /// **'You Both Get Rewards'**
  String get youBothGetRewards;

  /// No description provided for @youBothGetRewardsDesc.
  ///
  /// In en, this message translates to:
  /// **'You earn 500 points, they get 20% off first month'**
  String get youBothGetRewardsDesc;

  /// No description provided for @recentReferrals.
  ///
  /// In en, this message translates to:
  /// **'Recent Referrals'**
  String get recentReferrals;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied to clipboard'**
  String get referralCodeCopied;

  /// No description provided for @referralProgramLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load referral program. Please try again.'**
  String get referralProgramLoadError;

  /// No description provided for @referralRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get referralRetry;

  /// No description provided for @referralYourReward.
  ///
  /// In en, this message translates to:
  /// **'You earn {reward}'**
  String referralYourReward(String reward);

  /// No description provided for @referralFriendReward.
  ///
  /// In en, this message translates to:
  /// **'They get {reward}'**
  String referralFriendReward(String reward);

  /// No description provided for @referralOrDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get referralOrDivider;

  /// No description provided for @referralRewardDiscountPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String referralRewardDiscountPercent(String percent);

  /// No description provided for @referralRewardDiscountAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} off'**
  String referralRewardDiscountAmount(String amount);

  /// No description provided for @referralRewardFreeSession.
  ///
  /// In en, this message translates to:
  /// **'Free session'**
  String get referralRewardFreeSession;

  /// No description provided for @referralRewardFallback.
  ///
  /// In en, this message translates to:
  /// **'{label}'**
  String referralRewardFallback(String label);

  /// No description provided for @referralInviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent'**
  String get referralInviteSent;

  /// No description provided for @referralInvitePhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at most 30 characters'**
  String get referralInvitePhoneTooLong;

  /// No description provided for @referralHistoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load referral history.'**
  String get referralHistoryLoadError;

  /// No description provided for @referralHistoryRewardEarned.
  ///
  /// In en, this message translates to:
  /// **'Rewarded'**
  String get referralHistoryRewardEarned;

  /// No description provided for @referralHistoryRewardPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referralHistoryRewardPending;

  /// No description provided for @joinedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Joined {days} days ago'**
  String joinedDaysAgo(int days);

  /// No description provided for @changeHomeBranch.
  ///
  /// In en, this message translates to:
  /// **'Change Home Branch'**
  String get changeHomeBranch;

  /// No description provided for @updateHomeBranch.
  ///
  /// In en, this message translates to:
  /// **'Update Home Branch'**
  String get updateHomeBranch;

  /// No description provided for @searchTrainers.
  ///
  /// In en, this message translates to:
  /// **'Search trainers...'**
  String get searchTrainers;

  /// No description provided for @noTrainersTitle.
  ///
  /// In en, this message translates to:
  /// **'No trainers found'**
  String get noTrainersTitle;

  /// No description provided for @noTrainersFilteredDescription.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or change the filter above.'**
  String get noTrainersFilteredDescription;

  /// No description provided for @noTrainersDefaultDescription.
  ///
  /// In en, this message translates to:
  /// **'No trainers to show right now. Pull to refresh, or check back later.'**
  String get noTrainersDefaultDescription;

  /// No description provided for @allTrainers.
  ///
  /// In en, this message translates to:
  /// **'All Trainers'**
  String get allTrainers;

  /// No description provided for @matPilates.
  ///
  /// In en, this message translates to:
  /// **'Mat Pilates'**
  String get matPilates;

  /// No description provided for @reformer.
  ///
  /// In en, this message translates to:
  /// **'Reformer'**
  String get reformer;

  /// No description provided for @seniorFriendly.
  ///
  /// In en, this message translates to:
  /// **'Senior Friendly'**
  String get seniorFriendly;

  /// No description provided for @trainerNameDemo.
  ///
  /// In en, this message translates to:
  /// **'Aisha Sherin'**
  String get trainerNameDemo;

  /// No description provided for @powerPilatesSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Power Pilates Specialist'**
  String get powerPilatesSpecialist;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs exp.'**
  String yearsExperience(Object years);

  /// No description provided for @matCertified.
  ///
  /// In en, this message translates to:
  /// **'Mat Certified'**
  String get matCertified;

  /// No description provided for @trainerDescription.
  ///
  /// In en, this message translates to:
  /// **'Specializes in building core strength and helping clients achieve their fitness goals.'**
  String get trainerDescription;

  /// No description provided for @downtownStudio.
  ///
  /// In en, this message translates to:
  /// **'Downtown Studio'**
  String get downtownStudio;

  /// No description provided for @classesThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} classes this week'**
  String classesThisWeek(Object count);

  /// No description provided for @trainerDetails.
  ///
  /// In en, this message translates to:
  /// **'Trainer Details'**
  String get trainerDetails;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @classesTaught.
  ///
  /// In en, this message translates to:
  /// **'Classes Taught'**
  String get classesTaught;

  /// No description provided for @returnRate.
  ///
  /// In en, this message translates to:
  /// **'Return Rate'**
  String get returnRate;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @trainerAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Aisha brings over 8 years of experience in Pilates instruction, specializing in power flows that build strength and flexibility. She discovered Pilates after a sports injury and fell in love with the transformative power of controlled movement. Her classes are known for their perfect balance of challenge and mindfulness, helping students of all levels achieve their fitness goals while developing a deeper mind-body connection.'**
  String get trainerAboutDescription;

  /// No description provided for @teachingStyle.
  ///
  /// In en, this message translates to:
  /// **'Teaching Style'**
  String get teachingStyle;

  /// No description provided for @dynamicTxt.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get dynamicTxt;

  /// No description provided for @motivating.
  ///
  /// In en, this message translates to:
  /// **'Motivating'**
  String get motivating;

  /// No description provided for @detailOriented.
  ///
  /// In en, this message translates to:
  /// **'Detail Oriented'**
  String get detailOriented;

  /// No description provided for @challenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get challenging;

  /// No description provided for @supporting.
  ///
  /// In en, this message translates to:
  /// **'Supporting'**
  String get supporting;

  /// No description provided for @upcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Classes'**
  String get upcomingClasses;

  /// No description provided for @viewAllAishaClasses.
  ///
  /// In en, this message translates to:
  /// **'View All Aisha’s Classes'**
  String get viewAllAishaClasses;

  /// No description provided for @browseAllClasses.
  ///
  /// In en, this message translates to:
  /// **'Browse All Classes'**
  String get browseAllClasses;

  /// No description provided for @certificationsTraining.
  ///
  /// In en, this message translates to:
  /// **'Certifications & Training'**
  String get certificationsTraining;

  /// No description provided for @pmaCertifiedInstructor.
  ///
  /// In en, this message translates to:
  /// **'PMA Certified Pilates Instructor'**
  String get pmaCertifiedInstructor;

  /// No description provided for @matPilatesLevel3.
  ///
  /// In en, this message translates to:
  /// **'Mat Pilates Level III Certification'**
  String get matPilatesLevel3;

  /// No description provided for @sportsRehabilitationTraining.
  ///
  /// In en, this message translates to:
  /// **'Sports Rehabilitation Training'**
  String get sportsRehabilitationTraining;

  /// No description provided for @anatomyBiomechanicsCertificate.
  ///
  /// In en, this message translates to:
  /// **'Anatomy & Biomechanics Certificate'**
  String get anatomyBiomechanicsCertificate;

  /// No description provided for @loginOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent. Check your phone.'**
  String get loginOtpSent;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get loginErrorGeneric;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @phoneTenDigitsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 10-digit mobile number'**
  String get phoneTenDigitsRequired;

  /// No description provided for @pleaseCompletePersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required personal information fields.'**
  String get pleaseCompletePersonalInformation;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name (at least 2 characters)'**
  String get enterValidName;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age between 1 and 120'**
  String get enterValidAge;

  /// No description provided for @enterValidHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Please enter height between 50 and 300 cm'**
  String get enterValidHeightCm;

  /// No description provided for @enterValidWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Please enter weight between 20 and 400 kg'**
  String get enterValidWeightKg;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @registerOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent. Check your email or phone.'**
  String get registerOtpSent;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterLastName;

  /// No description provided for @forgotPasswordCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code was sent to your email.'**
  String get forgotPasswordCodeSent;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password was updated. Sign in with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @branchesCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load branches. Try again.'**
  String get branchesCouldNotLoad;

  /// No description provided for @noBranchesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No branches available.'**
  String get noBranchesAvailable;

  /// No description provided for @pleaseSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Please select a branch to continue.'**
  String get pleaseSelectBranch;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noClassesFound.
  ///
  /// In en, this message translates to:
  /// **'No classes found'**
  String get noClassesFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @availabilityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Availability unknown'**
  String get availabilityUnknown;

  /// No description provided for @trainerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown trainer'**
  String get trainerUnknown;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission is disabled. Please enable it in app settings so we can suggest the nearest branch.'**
  String get locationPermissionMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Take Picture'**
  String get takePicture;

  /// No description provided for @accessFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Access from gallery'**
  String get accessFromGallery;

  /// No description provided for @removeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Remove Profile Picture'**
  String get removeProfilePicture;
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
