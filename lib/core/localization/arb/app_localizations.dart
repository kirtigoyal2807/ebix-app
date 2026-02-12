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

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
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
  /// **'Enter the 4-digit code sent to'**
  String get enterCode;

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

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

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
  /// **'of {count} classes this month'**
  String ofClassesThisMonth(int count);

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
  /// **'Premium Plan (Monthly)'**
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
