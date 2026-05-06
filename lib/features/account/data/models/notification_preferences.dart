/// Channel-level notification preferences (e.g., class_reminder, booking_confirmed).
class ChannelPreference {
  const ChannelPreference({
    this.push,
    this.sms,
    this.email,
  });

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

  ChannelPreference copyWith({
    bool? push,
    bool? sms,
    bool? email,
  }) {
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

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final channelsMap = <String, ChannelPreference>{};
    final rawChannels = json['channels'];
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

    return NotificationPreferences(
      push: json['push'] as bool? ?? false,
      sms: json['sms'] as bool? ?? false,
      email: json['email'] as bool? ?? false,
      channels: channelsMap,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'push': push,
      'sms': sms,
      'email': email,
    };
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
