class HomeResponse {
  const HomeResponse({
    required this.banners,
    required this.membership,
    required this.progress,
    required this.featuredClasses,
    required this.classTypes,
    required this.topTrainers,
    required this.receivedGifts,
  });

  final List<HomeBanner> banners;
  final HomeMembership? membership;
  final HomeProgress? progress;
  final List<HomeFeaturedClass> featuredClasses;
  final List<HomeClassType> classTypes;
  final List<HomeTrainer> topTrainers;
  final List<HomeReceivedGift> receivedGifts;

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      banners: _toList(
        json['banners'],
      ).map((item) => HomeBanner.fromJson(item)).toList(),
      membership: _coerceMembership(json['membership']),
      progress: _toMapOrNull(json['progress']) == null
          ? null
          : HomeProgress.fromJson(_toMapOrNull(json['progress'])!),
      featuredClasses: _coerceFeaturedClasses(json['featuredClass']),
      classTypes: _toList(
        json['classTypes'],
      ).map((item) => HomeClassType.fromJson(item)).toList(),
      topTrainers: _toList(
        json['topTrainers'],
      ).map((item) => HomeTrainer.fromJson(item)).toList(),
      receivedGifts: _coerceReceivedGifts(json),
    );
  }
}

class HomeMembership {
  const HomeMembership({required this.planName, required this.totalSessions});

  final String? planName;
  final int? totalSessions;

  factory HomeMembership.fromJson(Map<String, dynamic> json) {
    final sessionPack = _toMapOrNull(json['session_pack']);
    return HomeMembership(
      planName:
          sessionPack?['planName']?.toString() ??
          json['planName']?.toString() ??
          json['name']?.toString(),
      totalSessions: _toIntOrNull(
        sessionPack?['totalSessions'] ?? json['totalSessions'],
      ),
    );
  }
}

class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionType,
    required this.actionPayload,
  });

  final int? id;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? actionType;
  final Map<String, dynamic>? actionPayload;

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: _toIntOrNull(json['id']),
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      actionType: json['actionType']?.toString(),
      actionPayload: _toMapOrNull(json['actionPayload']),
    );
  }
}

class HomeProgress {
  const HomeProgress({
    required this.mtdAttendedClasses,
    required this.mtdAttendedMinutes,
    required this.monthlyTargetClasses,
    required this.goalPercent,
  });

  final int mtdAttendedClasses;
  final int mtdAttendedMinutes;
  final int monthlyTargetClasses;
  final int goalPercent;

  factory HomeProgress.fromJson(Map<String, dynamic> json) {
    return HomeProgress(
      mtdAttendedClasses: _toIntOrZero(json['mtdAttendedClasses']),
      mtdAttendedMinutes: _toIntOrZero(json['mtdAttendedMinutes']),
      monthlyTargetClasses: _toIntOrZero(json['monthlyTargetClasses']),
      goalPercent: _toIntOrZero(json['goalPercent']),
    );
  }
}

class HomeFeaturedClass {
  const HomeFeaturedClass({
    required this.className,
    required this.trainerName,
    required this.branchName,
    required this.startAt,
    required this.image,
    required this.spotsLeft,
    required this.inPlan,
  });

  final String? className;
  final String? trainerName;
  final String? branchName;
  final DateTime? startAt;
  final String? image;
  final int? spotsLeft;
  final bool? inPlan;

  factory HomeFeaturedClass.fromJson(Map<String, dynamic> json) {
    final availability = _toMapOrNull(json['availability']);
    final flags = _toMapOrNull(json['flags']);
    return HomeFeaturedClass(
      className: json['className']?.toString(),
      trainerName: json['trainerName']?.toString(),
      branchName: json['branchName']?.toString(),
      startAt: DateTime.tryParse(json['startAt']?.toString() ?? ''),
      image: json['image']?.toString(),
      spotsLeft: _toIntOrNull(availability?['spotsLeft']),
      inPlan: flags?['inPlan'] is bool ? flags!['inPlan'] as bool : null,
    );
  }
}

class HomeClassType {
  const HomeClassType({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
  });

  final int? id;
  final String? name;
  final String? imageUrl;
  final int? sortOrder;

  factory HomeClassType.fromJson(Map<String, dynamic> json) {
    return HomeClassType(
      id: _toIntOrNull(json['id']),
      name: json['name']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      sortOrder: _toIntOrNull(json['sortOrder']),
    );
  }
}

class HomeTrainer {
  const HomeTrainer({
    required this.id,
    required this.displayName,
    required this.avgRating,
    required this.specialties,
    required this.imageUrl,
  });

  final String? id;
  final String? displayName;
  final String? avgRating;
  final List<String> specialties;
  final String? imageUrl;

  factory HomeTrainer.fromJson(Map<String, dynamic> json) {
    return HomeTrainer(
      id: json['id']?.toString(),
      displayName: json['displayName']?.toString(),
      avgRating: json['avgRating']?.toString(),
      specialties: _toList(json['specialties'])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }
}

class HomeReceivedGift {
  const HomeReceivedGift({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.senderName,
  });

  final String? id;
  final String? title;
  final String? subtitle;
  final String? senderName;

  factory HomeReceivedGift.fromJson(Map<String, dynamic> json) {
    return HomeReceivedGift(
      id: json['id']?.toString(),
      title:
          json['title']?.toString() ??
          json['giftTitle']?.toString() ??
          json['giftName']?.toString(),
      subtitle:
          json['subtitle']?.toString() ??
          json['message']?.toString() ??
          json['description']?.toString(),
      senderName:
          json['senderName']?.toString() ??
          json['sender']?.toString() ??
          _toMapOrNull(json['senderUser'])?['name']?.toString(),
    );
  }
}

HomeMembership? _coerceMembership(dynamic raw) {
  final map = _toMapOrNull(raw);
  if (map != null) {
    return HomeMembership.fromJson(map);
  }

  final list = _toList(raw);
  if (list.isEmpty) {
    return null;
  }
  return HomeMembership.fromJson(list.first);
}

List<HomeFeaturedClass> _coerceFeaturedClasses(dynamic raw) {
  final map = _toMapOrNull(raw);
  if (map != null) {
    return [HomeFeaturedClass.fromJson(map)];
  }
  final list = _toList(raw);
  return list.map((item) => HomeFeaturedClass.fromJson(item)).toList();
}

List<HomeReceivedGift> _coerceReceivedGifts(Map<String, dynamic> json) {
  final keys = <String>[
    'receivedGifts',
    'receivedGiftCards',
    'giftCards',
    'receivedGiftCard',
  ];
  for (final key in keys) {
    final list = _toList(json[key]);
    if (list.isNotEmpty) {
      return list.map((item) => HomeReceivedGift.fromJson(item)).toList();
    }
  }
  return const [];
}

List<Map<String, dynamic>> _toList(dynamic raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic>? _toMapOrNull(dynamic raw) {
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return null;
}

int _toIntOrZero(dynamic value) {
  return _toIntOrNull(value) ?? 0;
}

int? _toIntOrNull(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '');
}
