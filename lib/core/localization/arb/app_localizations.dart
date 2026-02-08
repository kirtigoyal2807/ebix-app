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

  /// No description provided for @withTrainer.
  ///
  /// In en, this message translates to:
  /// **'with {trainer}'**
  String withTrainer(String trainer);

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} Spots Left'**
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
  /// **'Check In'**
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
