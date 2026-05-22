import 'package:pilates_app/core/models/membership_snapshot.dart';

int? _jsonInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _jsonDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

bool? _jsonBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final s = value.toString().trim().toLowerCase();
  if (s == 'true' || s == '1' || s == 'yes') return true;
  if (s == 'false' || s == '0' || s == 'no') return false;
  return null;
}

/// Subset of profile fields from `POST /auth/login` -> `data.user`, or [`GET /customers/profile`].
class AuthUser {
  const AuthUser({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.avatar,
    this.dateOfBirth,
    this.language,
    this.homeBranch,
    this.brands,
    this.goals,
    this.subscriptions,
    this.pendingGift,
    this.hasPendingGiftKey = false,
    this.emailVerified,
    this.phoneVerified,
    this.createdAt,
    this.updatedAt,

    /// From `membership[]` / `planName` on profile (aligned with [`GET /home`] `membership`).
    this.membershipPlanName,

    /// From `membership[].totalSessions` or top-level helpers when backend sends them.
    this.membershipTotalSessions,

    /// From `membership[].sessionsRemaining` (`sessionsRemaining`) when provided.
    this.membershipSessionsRemaining,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;
  final String? heightCm;
  final String? weightKg;
  final String? gender;
  final String? avatar;

  /// From profile / login payload when the API sends `dob`, `date_of_birth`, etc.
  final DateTime? dateOfBirth;

  /// Preferred language: `en` | `ar`.
  final String? language;

  /// Home branch from `/customers/profile` — abbreviated BranchResource.
  final UserHomeBranch? homeBranch;

  /// Brands the customer belongs to: `[{ id, name }]`.
  final List<UserBrand>? brands;

  /// Goals from `/customers/profile`: `{ experience, goal, monthlyGoal }`.
  final UserGoals? goals;

  /// Active subscriptions from `/customers/profile`.
  final List<UserSubscription>? subscriptions;

  /// Oldest unredeemed gift sent to this customer's phone.
  /// Null when there's no pending gift.
  final PendingGift? pendingGift;

  /// True when the API response contained the `pendingGift` key — used to
  /// distinguish "no pending gift" (null) from "field absent" (e.g. login response
  /// that never carries this field). When the key was present and explicitly null,
  /// we should clear any previously stored pending gift.
  final bool hasPendingGiftKey;

  /// Whether email has been verified.
  final bool? emailVerified;

  /// Whether phone has been verified.
  final bool? phoneVerified;

  /// ISO 8601 created timestamp.
  final DateTime? createdAt;

  /// ISO 8601 updated timestamp.
  final DateTime? updatedAt;

  final String? membershipPlanName;
  final int? membershipTotalSessions;
  final int? membershipSessionsRemaining;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final root = _unwrapProfileRoot(json);
    final membershipSnap = parseMembershipField(root['membership']);

    // Parse subscriptions for membership info fallback
    final subscriptionsList = _parseSubscriptions(root['subscriptions']);
    final activeSubscription = subscriptionsList?.isNotEmpty == true
        ? subscriptionsList!.first
        : null;

    return AuthUser(
      id: root['id']?.toString(),
      firstName:
          root['first_name'] as String? ?? root['firstName'] as String?,
      lastName: root['last_name'] as String? ?? root['lastName'] as String?,
      name: root['name'] as String? ?? root['full_name'] as String?,
      email: root['email'] as String?,
      phone: root['phone'] as String?,
      heightCm: _trimOrNull(
        root['height_cm'] ?? root['heightCm'] ?? root['height'],
      ),
      weightKg: _trimOrNull(
        root['weight_kg'] ?? root['weightKg'] ?? root['weight'],
      ),
      gender: _trimOrNull(root['gender']),
      avatar: root['avatar'] as String?,
      dateOfBirth: _parseDateOfBirth(
        root['dob'] ??
            root['date_of_birth'] ??
            root['dateOfBirth'] ??
            root['birth_date'],
      ),
      language: _trimOrNull(root['language']),
      homeBranch: _parseHomeBranch(
        root['homeBranch'] ??
            root['home_branch'] ??
            _homeBranchFromFlatId(root),
      ),
      brands: _parseBrands(root['brands']),
      goals: _parseGoals(root['goals']),
      subscriptions: subscriptionsList,
      pendingGift:
          _parsePendingGift(root['pendingGift'] ?? root['pending_gift']),
      hasPendingGiftKey: root.containsKey('pendingGift') ||
          root.containsKey('pending_gift'),
      emailVerified: root['emailVerified'] as bool?,
      phoneVerified: root['phoneVerified'] as bool?,
      createdAt: _parseDateTime(root['createdAt']),
      updatedAt: _parseDateTime(root['updatedAt']),
      membershipPlanName:
          membershipSnap?.planName ??
          activeSubscription?.product?.name ??
          _trimOrNull(root['membershipPlanName']) ??
          _trimOrNull(root['planName']) ??
          _trimOrNull(root['plan_name']),
      membershipTotalSessions:
          membershipSnap?.totalSessions ??
          activeSubscription?.sessions?.total ??
          _parseInt(root['membershipTotalSessions']) ??
          _parseInt(root['totalSessions']) ??
          _parseInt(root['total_sessions']),
      membershipSessionsRemaining:
          membershipSnap?.sessionsRemaining ??
          activeSubscription?.sessions?.remaining ??
          _parseInt(root['membershipSessionsRemaining']) ??
          _parseInt(root['sessionsRemaining']) ??
          _parseInt(root['sessions_remaining']),
    );
  }

  /// Profile payloads may nest fields under `customer` / `user`.
  static Map<String, dynamic> _unwrapProfileRoot(Map<String, dynamic> json) {
    for (final key in const ['customer', 'user', 'profile']) {
      final nested = json[key];
      if (nested is Map<String, dynamic>) {
        return {...Map<String, dynamic>.from(nested), ...json}..remove(key);
      }
      if (nested is Map) {
        return {...Map<String, dynamic>.from(nested), ...json}..remove(key);
      }
    }
    return json;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'name': name,
    'email': email,
    'phone': phone,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'gender': gender,
    'avatar': avatar,
    if (dateOfBirth != null)
      'dob': dateOfBirth!.toIso8601String().split('T').first,
    'language': language,
    if (homeBranch != null) 'homeBranch': homeBranch!.toJson(),
    if (brands != null) 'brands': brands!.map((b) => b.toJson()).toList(),
    if (goals != null) 'goals': goals!.toJson(),
    if (subscriptions != null)
      'subscriptions': subscriptions!.map((s) => s.toJson()).toList(),
    'pendingGift': pendingGift?.toJson(),
    'emailVerified': emailVerified,
    'phoneVerified': phoneVerified,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    'membershipPlanName': membershipPlanName,
    'membershipTotalSessions': membershipTotalSessions,
    'membershipSessionsRemaining': membershipSessionsRemaining,
  };

  int? get ageYears {
    final d = dateOfBirth;
    if (d == null) return null;
    final now = DateTime.now();
    var age = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) {
      age--;
    }
    return age;
  }

  bool get _hasStoredMembershipHints =>
      (membershipPlanName?.trim().isNotEmpty ?? false) ||
      membershipTotalSessions != null ||
      membershipSessionsRemaining != null;

  /// Fallback when [`GET /home`] omits membership but [`GET /customers/profile`] carries plan info.
  bool get showsMembershipWithoutHomePayload => _hasStoredMembershipHints;

  /// First name for greetings (home header, etc.).
  String get greetingName {
    final f = firstName?.trim();
    if (f != null && f.isNotEmpty) return f;
    final n = name?.trim();
    if (n != null && n.isNotEmpty) return n.split(RegExp(r'\s+')).first;
    final e = email?.trim();
    if (e != null && e.isNotEmpty) return e.split('@').first;
    final p = phone?.trim();
    if (p != null && p.isNotEmpty) return p;
    return '';
  }

  static String? _trimOrNull(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateOfBirth(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  static UserHomeBranch? _parseHomeBranch(dynamic value) {
    if (value == null) return null;
    if (value is int || value is num) {
      final id = _jsonInt(value);
      return id != null && id > 0 ? UserHomeBranch(id: id) : null;
    }
    if (value is String) {
      final id = int.tryParse(value.trim());
      return id != null && id > 0 ? UserHomeBranch(id: id) : null;
    }
    if (value is! Map<String, dynamic>) {
      if (value is Map) {
        return UserHomeBranch.fromJson(Map<String, dynamic>.from(value));
      }
      return null;
    }
    return UserHomeBranch.fromJson(value);
  }

  /// When the API only returns `homeBranchId` / `home_branch_id` on the profile root.
  static Map<String, dynamic>? _homeBranchFromFlatId(Map<String, dynamic> json) {
    final id = _jsonInt(
      json['homeBranchId'] ??
          json['home_branch_id'] ??
          json['homeBranch_id'],
    );
    if (id == null || id <= 0) return null;
    return {
      'id': id,
      'name': json['homeBranchName'] ?? json['home_branch_name'],
      'slug': json['homeBranchSlug'] ?? json['home_branch_slug'],
      'code': json['homeBranchCode'] ?? json['home_branch_code'],
    };
  }

  static List<UserBrand>? _parseBrands(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;
    return value
        .whereType<Map<String, dynamic>>()
        .map((e) => UserBrand.fromJson(e))
        .toList();
  }

  static UserGoals? _parseGoals(dynamic value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic>) return null;
    return UserGoals.fromJson(value);
  }

  static List<UserSubscription>? _parseSubscriptions(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;
    return value
        .whereType<Map<String, dynamic>>()
        .map((e) => UserSubscription.fromJson(e))
        .toList();
  }

  static PendingGift? _parsePendingGift(dynamic value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic>) return null;
    return PendingGift.fromJson(value);
  }
}

/// Home branch from `/customers/profile` response.
class UserHomeBranch {
  const UserHomeBranch({this.id, this.name, this.slug, this.code});

  final int? id;
  final String? name;
  final String? slug;
  final String? code;

  factory UserHomeBranch.fromJson(Map<String, dynamic> json) {
    return UserHomeBranch(
      id: _jsonInt(
        json['id'] ??
            json['branchId'] ??
            json['branch_id'] ??
            json['homeBranchId'] ??
            json['home_branch_id'],
      ),
      name: json['name'] as String? ?? json['title'] as String?,
      slug: json['slug'] as String?,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'code': code,
  };
}

/// Brand from `/customers/profile` response.
class UserBrand {
  const UserBrand({this.id, this.name});

  final int? id;
  final String? name;

  factory UserBrand.fromJson(Map<String, dynamic> json) {
    return UserBrand(id: _jsonInt(json['id']), name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

/// Goals from `/customers/profile` response.
class UserGoals {
  const UserGoals({this.experience, this.goal, this.monthlyGoal});

  final String? experience;
  final String? goal;
  final int? monthlyGoal;

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      experience: json['experience'] as String?,
      goal: json['goal'] as String?,
      monthlyGoal:
          _jsonInt(json['monthlyGoal']) ?? _jsonInt(json['monthly_goal']),
    );
  }

  Map<String, dynamic> toJson() => {
    'experience': experience,
    'goal': goal,
    'monthlyGoal': monthlyGoal,
  };
}

/// Subscription from `/customers/profile` response.
class UserSubscription {
  const UserSubscription({
    this.id,
    this.status,
    this.entitlementType,
    this.startsAt,
    this.expiresAt,
    this.isActive,
    this.isPaid,
    this.pricePaid,
    this.isTransferable,
    this.product,
    this.sessions,
    this.freezes,
  });

  final String? id;
  final String? status;
  final String? entitlementType;
  final String? startsAt;
  final String? expiresAt;
  final bool? isActive;
  final bool? isPaid;
  final double? pricePaid;
  final bool? isTransferable;
  final SubscriptionProduct? product;
  final SubscriptionSessions? sessions;
  final List<dynamic>? freezes;

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id']?.toString(),
      status: json['status'] as String?,
      entitlementType: json['entitlementType'] as String?,
      startsAt: json['startsAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      isActive: json['isActive'] as bool?,
      isPaid: json['isPaid'] as bool?,
      pricePaid: _jsonDouble(json['pricePaid']),
      isTransferable: json['isTransferable'] as bool?,
      product: json['product'] != null
          ? SubscriptionProduct.fromJson(
              json['product'] as Map<String, dynamic>,
            )
          : null,
      sessions: json['sessions'] != null
          ? SubscriptionSessions.fromJson(
              json['sessions'] as Map<String, dynamic>,
            )
          : null,
      freezes: json['freezes'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'entitlementType': entitlementType,
    'startsAt': startsAt,
    'expiresAt': expiresAt,
    'isActive': isActive,
    'isPaid': isPaid,
    'pricePaid': pricePaid,
    'isTransferable': isTransferable,
    'product': product?.toJson(),
    'sessions': sessions?.toJson(),
    'freezes': freezes,
  };
}

/// Product in subscription from `/customers/profile` response.
class SubscriptionProduct {
  const SubscriptionProduct({this.id, this.name});

  final int? id;
  final String? name;

  factory SubscriptionProduct.fromJson(Map<String, dynamic> json) {
    return SubscriptionProduct(
      id: _jsonInt(json['id']),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

/// Pending gift from `/customers/profile` response — oldest unredeemed gift sent to this
/// customer's phone. Use [canBeRedeemed] to gate the redemption UI.
class PendingGift {
  const PendingGift({
    this.id,
    this.status,
    this.statusLabel,
    this.redemptionCode,
    this.recipient,
    this.message,
    this.deliveryDate,
    this.sentAt,
    this.redeemedAt,
    this.expiresAt,
    this.isRedeemed,
    this.isExpired,
    this.canBeRedeemed,
    this.plan,
    this.createdAt,
  });

  final String? id;
  final String? status;
  final String? statusLabel;
  final String? redemptionCode;
  final PendingGiftRecipient? recipient;
  final String? message;
  final String? deliveryDate;
  final String? sentAt;
  final String? redeemedAt;
  final String? expiresAt;
  final bool? isRedeemed;
  final bool? isExpired;
  final bool? canBeRedeemed;
  final PendingGiftPlan? plan;
  final String? createdAt;

  factory PendingGift.fromJson(Map<String, dynamic> json) {
    final statusRaw = json['status'];
    String? statusValue;
    String? statusLabel;
    if (statusRaw is Map<String, dynamic>) {
      statusValue = statusRaw['value'] as String?;
      statusLabel = statusRaw['label'] as String?;
    } else if (statusRaw is String) {
      statusValue = statusRaw;
    }

    PendingGiftRecipient? recipient;
    final recipientRaw = json['recipient'];
    if (recipientRaw is Map<String, dynamic>) {
      recipient = PendingGiftRecipient.fromJson(recipientRaw);
    }

    PendingGiftPlan? plan;
    final planRaw = json['plan'];
    if (planRaw is Map<String, dynamic>) {
      plan = PendingGiftPlan.fromJson(planRaw);
    }

    return PendingGift(
      id: json['id']?.toString(),
      status: statusValue,
      statusLabel: statusLabel,
      redemptionCode: json['redemptionCode'] as String?,
      recipient: recipient,
      message: json['message'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      sentAt: json['sentAt'] as String?,
      redeemedAt: json['redeemedAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      isRedeemed: _jsonBool(json['isRedeemed'] ?? json['is_redeemed']),
      isExpired: _jsonBool(json['isExpired'] ?? json['is_expired']),
      canBeRedeemed: _jsonBool(
        json['canBeRedeemed'] ?? json['can_be_redeemed'],
      ),
      plan: plan,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status == null
        ? null
        : {'value': status, if (statusLabel != null) 'label': statusLabel},
    'redemptionCode': redemptionCode,
    'recipient': recipient?.toJson(),
    'message': message,
    'deliveryDate': deliveryDate,
    'sentAt': sentAt,
    'redeemedAt': redeemedAt,
    'expiresAt': expiresAt,
    'isRedeemed': isRedeemed,
    'isExpired': isExpired,
    'canBeRedeemed': canBeRedeemed,
    'plan': plan?.toJson(),
    'createdAt': createdAt,
  };
}

/// Gift plan metadata on a [PendingGift].
class PendingGiftPlan {
  const PendingGiftPlan({this.id, this.name, this.description});

  final String? id;
  final String? name;
  final String? description;

  factory PendingGiftPlan.fromJson(Map<String, dynamic> json) {
    return PendingGiftPlan(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}

/// Recipient block on a [PendingGift].
class PendingGiftRecipient {
  const PendingGiftRecipient({this.name, this.phone, this.email});

  final String? name;
  final String? phone;
  final String? email;

  factory PendingGiftRecipient.fromJson(Map<String, dynamic> json) {
    return PendingGiftRecipient(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
  };
}

/// Sessions in subscription from `/customers/profile` response.
class SubscriptionSessions {
  const SubscriptionSessions({this.total, this.used, this.remaining});

  final int? total;
  final int? used;
  final int? remaining;

  factory SubscriptionSessions.fromJson(Map<String, dynamic> json) {
    return SubscriptionSessions(
      total: _jsonInt(json['total']),
      used: _jsonInt(json['used']),
      remaining: _jsonInt(json['remaining']),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'used': used,
    'remaining': remaining,
  };
}
