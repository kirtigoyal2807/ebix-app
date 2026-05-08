/// Channel-level notification preferences (e.g., class_reminder, booking_confirmed).
class ChannelPreference {
  const ChannelPreference({this.push, this.sms, this.email});

  final bool? push;
  final bool? sms;
  final bool? email;

  factory ChannelPreference.fromJson(Map<String, dynamic> json) {
    return ChannelPreference(
      push: json['push'] as bool?,
      sms: json['sms'] as bool?,
      email: json['email'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (push != null) map['push'] = push;
    if (sms != null) map['sms'] = sms;
    if (email != null) map['email'] = email;
    return map;
  }

  ChannelPreference copyWith({bool? push, bool? sms, bool? email}) {
    return ChannelPreference(
      push: push ?? this.push,
      sms: sms ?? this.sms,
      email: email ?? this.email,
    );
  }
}

/// `data` object from `GET /notifications/preferences`.
class NotificationPreferences {
  const NotificationPreferences({
    this.push = false,
    this.sms = false,
    this.email = false,
    this.channels = const {},
  });

  final bool push;
  final bool sms;
  final bool email;
  final Map<String, ChannelPreference> channels;

  static Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static bool? _asBool(dynamic value) {
    if (value is bool) return value;
    return null;
  }

  static void _setBoolChannel(
    Map<String, ChannelPreference> target,
    String key,
    dynamic value,
  ) {
    final parsed = _asBool(value);
    if (parsed == null) return;
    target[key] = ChannelPreference(push: parsed);
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final source = _asStringDynamicMap(json['preferences']) ?? json;
    final channelsMap = <String, ChannelPreference>{};
    final rawChannels = source['channels'];
    if (rawChannels is Map<String, dynamic>) {
      for (final entry in rawChannels.entries) {
        if (entry.value is Map<String, dynamic>) {
          channelsMap[entry.key] = ChannelPreference.fromJson(
            entry.value as Map<String, dynamic>,
          );
        } else if (entry.value is Map) {
          channelsMap[entry.key] = ChannelPreference.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }

    final classNotifications = _asStringDynamicMap(
      source['classNotifications'],
    );
    _setBoolChannel(
      channelsMap,
      'before_class_starts',
      classNotifications?['beforeClassStart'],
    );
    _setBoolChannel(
      channelsMap,
      'day_before_reminder',
      classNotifications?['dayBeforeReminder'],
    );

    final subscriptionNotifications = _asStringDynamicMap(
      source['subscriptionNotifications'],
    );
    _setBoolChannel(
      channelsMap,
      'payment_confirmation',
      subscriptionNotifications?['paymentConfirmations'],
    );
    _setBoolChannel(
      channelsMap,
      'renewal_reminder',
      subscriptionNotifications?['renewalReminders'],
    );

    final marketingNotifications = _asStringDynamicMap(
      source['marketingNotifications'],
    );
    _setBoolChannel(
      channelsMap,
      'promotions',
      marketingNotifications?['promotions'],
    );
    _setBoolChannel(
      channelsMap,
      'app_updates',
      marketingNotifications?['productUpdates'],
    );

    final loyaltyNotifications = _asStringDynamicMap(
      source['loyaltyNotifications'],
    );
    _setBoolChannel(
      channelsMap,
      'new_challenges',
      loyaltyNotifications?['challengeUpdates'],
    );
    _setBoolChannel(
      channelsMap,
      'rewards_earned',
      loyaltyNotifications?['pointsEarned'],
    );
    _setBoolChannel(
      channelsMap,
      'points_earned',
      loyaltyNotifications?['pointsEarned'],
    );

    final channelToggles = _asStringDynamicMap(source['channels']);

    return NotificationPreferences(
      push:
          _asBool(source['allNotifications']) ??
          _asBool(source['push']) ??
          _asBool(channelToggles?['push']) ??
          false,
      sms: _asBool(source['sms']) ?? _asBool(channelToggles?['sms']) ?? false,
      email:
          _asBool(source['email']) ??
          _asBool(channelToggles?['email']) ??
          false,
      channels: channelsMap,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'push': push, 'sms': sms, 'email': email};
    if (channels.isNotEmpty) {
      map['channels'] = channels.map((k, v) => MapEntry(k, v.toJson()));
    }
    return map;
  }

  NotificationPreferences copyWith({
    bool? push,
    bool? sms,
    bool? email,
    Map<String, ChannelPreference>? channels,
  }) {
    return NotificationPreferences(
      push: push ?? this.push,
      sms: sms ?? this.sms,
      email: email ?? this.email,
      channels: channels ?? this.channels,
    );
  }
}
