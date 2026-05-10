bool? _asBool(dynamic value) {
  if (value is bool) return value;
  return null;
}

/// Global delivery toggles under [NotificationPreferences.channels].
class NotificationGlobalChannels {
  const NotificationGlobalChannels({
    this.inApp = false,
    this.push = false,
    this.email = false,
    this.sms = false,
  });

  final bool inApp;
  final bool push;
  final bool email;
  final bool sms;

  factory NotificationGlobalChannels.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NotificationGlobalChannels();
    }
    return NotificationGlobalChannels(
      inApp: _asBool(json['inApp']) ?? false,
      push: _asBool(json['push']) ?? false,
      email: _asBool(json['email']) ?? false,
      sms: _asBool(json['sms']) ?? false,
    );
  }
}

class ClassNotificationPreferences {
  const ClassNotificationPreferences({
    this.beforeClassStart = false,
    this.dayBeforeReminder = false,
    this.bookingConfirmed = false,
    this.bookingCancelled = false,
    this.waitlistPromoted = false,
  });

  final bool beforeClassStart;
  final bool dayBeforeReminder;
  final bool bookingConfirmed;
  final bool bookingCancelled;
  final bool waitlistPromoted;

  factory ClassNotificationPreferences.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ClassNotificationPreferences();
    return ClassNotificationPreferences(
      beforeClassStart: _asBool(json['beforeClassStart']) ?? false,
      dayBeforeReminder: _asBool(json['dayBeforeReminder']) ?? false,
      bookingConfirmed: _asBool(json['bookingConfirmed']) ?? false,
      bookingCancelled: _asBool(json['bookingCancelled']) ?? false,
      waitlistPromoted: _asBool(json['waitlistPromoted']) ?? false,
    );
  }
}

class SubscriptionNotificationPreferences {
  const SubscriptionNotificationPreferences({
    this.paymentConfirmations = false,
    this.renewalReminders = false,
    this.expiryReminders = false,
  });

  final bool paymentConfirmations;
  final bool renewalReminders;
  final bool expiryReminders;

  factory SubscriptionNotificationPreferences.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return const SubscriptionNotificationPreferences();
    return SubscriptionNotificationPreferences(
      paymentConfirmations: _asBool(json['paymentConfirmations']) ?? false,
      renewalReminders: _asBool(json['renewalReminders']) ?? false,
      expiryReminders: _asBool(json['expiryReminders']) ?? false,
    );
  }
}

class LoyaltyNotificationPreferences {
  const LoyaltyNotificationPreferences({
    this.pointsEarned = false,
    this.rewardRedeemed = false,
    this.challengeUpdates = false,
    this.badgeEarned = false,
  });

  final bool pointsEarned;
  final bool rewardRedeemed;
  final bool challengeUpdates;
  final bool badgeEarned;

  factory LoyaltyNotificationPreferences.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoyaltyNotificationPreferences();
    return LoyaltyNotificationPreferences(
      pointsEarned: _asBool(json['pointsEarned']) ?? false,
      rewardRedeemed: _asBool(json['rewardRedeemed']) ?? false,
      challengeUpdates: _asBool(json['challengeUpdates']) ?? false,
      badgeEarned: _asBool(json['badgeEarned']) ?? false,
    );
  }
}

class ReferralNotificationPreferences {
  const ReferralNotificationPreferences({
    this.referralSuccess = false,
    this.inviteUpdates = false,
  });

  final bool referralSuccess;
  final bool inviteUpdates;

  factory ReferralNotificationPreferences.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReferralNotificationPreferences();
    return ReferralNotificationPreferences(
      referralSuccess: _asBool(json['referralSuccess']) ?? false,
      inviteUpdates: _asBool(json['inviteUpdates']) ?? false,
    );
  }
}

class MarketingNotificationPreferences {
  const MarketingNotificationPreferences({
    this.promotions = false,
    this.productUpdates = false,
  });

  final bool promotions;
  final bool productUpdates;

  factory MarketingNotificationPreferences.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return const MarketingNotificationPreferences();
    return MarketingNotificationPreferences(
      promotions: _asBool(json['promotions']) ?? false,
      productUpdates: _asBool(json['productUpdates']) ?? false,
    );
  }
}

/// Parsed notification preferences for GET `/notifications/preferences` envelope [data].
class NotificationPreferences {
  const NotificationPreferences({
    this.rootPush = false,
    this.rootEmail = false,
    this.allNotifications = false,
    this.channels = const NotificationGlobalChannels(),
    this.classNotifications = const ClassNotificationPreferences(),
    this.subscriptionNotifications =
        const SubscriptionNotificationPreferences(),
    this.loyaltyNotifications = const LoyaltyNotificationPreferences(),
    this.referralNotifications = const ReferralNotificationPreferences(),
    this.marketingNotifications = const MarketingNotificationPreferences(),
  });

  /// Top-level request fields (PUT), when present on GET.
  final bool rootPush;
  final bool rootEmail;

  final bool allNotifications;
  final NotificationGlobalChannels channels;
  final ClassNotificationPreferences classNotifications;
  final SubscriptionNotificationPreferences subscriptionNotifications;
  final LoyaltyNotificationPreferences loyaltyNotifications;
  final ReferralNotificationPreferences referralNotifications;
  final MarketingNotificationPreferences marketingNotifications;

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final prefs = _asMap(json['preferences']) ?? json;

    final channelsJson = _asMap(prefs['channels']);
    final globalChannels = NotificationGlobalChannels.fromJson(channelsJson);

    final rootPush = json.containsKey('push')
        ? (_asBool(json['push']) ?? false)
        : globalChannels.push;
    final rootEmail = json.containsKey('email')
        ? (_asBool(json['email']) ?? false)
        : globalChannels.email;

    return NotificationPreferences(
      rootPush: rootPush,
      rootEmail: rootEmail,
      allNotifications: _asBool(prefs['allNotifications']) ?? false,
      channels: globalChannels,
      classNotifications: ClassNotificationPreferences.fromJson(
        _asMap(prefs['classNotifications']),
      ),
      subscriptionNotifications: SubscriptionNotificationPreferences.fromJson(
        _asMap(prefs['subscriptionNotifications']),
      ),
      loyaltyNotifications: LoyaltyNotificationPreferences.fromJson(
        _asMap(prefs['loyaltyNotifications']),
      ),
      referralNotifications: ReferralNotificationPreferences.fromJson(
        _asMap(prefs['referralNotifications']),
      ),
      marketingNotifications: MarketingNotificationPreferences.fromJson(
        _asMap(prefs['marketingNotifications']),
      ),
    );
  }

  NotificationPreferences copyWith({
    bool? rootPush,
    bool? rootEmail,
    bool? allNotifications,
    NotificationGlobalChannels? channels,
    ClassNotificationPreferences? classNotifications,
    SubscriptionNotificationPreferences? subscriptionNotifications,
    LoyaltyNotificationPreferences? loyaltyNotifications,
    ReferralNotificationPreferences? referralNotifications,
    MarketingNotificationPreferences? marketingNotifications,
  }) {
    return NotificationPreferences(
      rootPush: rootPush ?? this.rootPush,
      rootEmail: rootEmail ?? this.rootEmail,
      allNotifications: allNotifications ?? this.allNotifications,
      channels: channels ?? this.channels,
      classNotifications: classNotifications ?? this.classNotifications,
      subscriptionNotifications:
          subscriptionNotifications ?? this.subscriptionNotifications,
      loyaltyNotifications: loyaltyNotifications ?? this.loyaltyNotifications,
      referralNotifications:
          referralNotifications ?? this.referralNotifications,
      marketingNotifications:
          marketingNotifications ?? this.marketingNotifications,
    );
  }
}
