num? _referralRewardValueFromJson(dynamic raw) {
  if (raw == null) {
    return null;
  }
  if (raw is num) {
    return raw;
  }
  if (raw is String) {
    return num.tryParse(raw.trim());
  }
  return null;
}

class ReferralReward {
  const ReferralReward({required this.type, this.value});

  final String type;
  final num? value;

  factory ReferralReward.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReferralReward(type: '', value: null);
    }
    return ReferralReward(
      type: json['type'] as String? ?? '',
      value: _referralRewardValueFromJson(json['value']),
    );
  }
}

class ReferralProgramDetails {
  const ReferralProgramDetails({
    required this.referralCode,
    required this.shareUrl,
    required this.referrerReward,
    required this.referredReward,
  });

  final String referralCode;
  final String shareUrl;
  final ReferralReward referrerReward;
  final ReferralReward referredReward;

  factory ReferralProgramDetails.fromJson(Map<String, dynamic> json) {
    return ReferralProgramDetails(
      referralCode: json['referralCode'] as String? ?? '',
      shareUrl: json['shareUrl'] as String? ?? '',
      referrerReward: ReferralReward.fromJson(
        json['referrerReward'] as Map<String, dynamic>?,
      ),
      referredReward: ReferralReward.fromJson(
        json['referredReward'] as Map<String, dynamic>?,
      ),
    );
  }
}
