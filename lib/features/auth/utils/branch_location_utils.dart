import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';

/// User coordinates for `GET /branches?lat=&lng=` and distance labels.
class BranchLocationCoords {
  const BranchLocationCoords({this.lat, this.lng});

  final double? lat;
  final double? lng;

  bool get hasCoords => lat != null && lng != null;
}

/// Location permission + distance helpers shared by branch picker screens.
abstract final class BranchLocationUtils {
  /// Requests permission, reads position when allowed, always returns (may be empty).
  static Future<BranchLocationCoords> resolveUserCoordinates(
    BuildContext context,
  ) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        await showLocationSettingsDialog(context);
      }
      return const BranchLocationCoords();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return const BranchLocationCoords();
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return BranchLocationCoords(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (_) {
      return const BranchLocationCoords();
    }
  }

  static Future<void> showLocationSettingsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.locationPermissionTitle),
        content: Text(context.l10n.locationPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.notNow),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Geolocator.openAppSettings();
            },
            child: Text(context.l10n.openSettings),
          ),
        ],
      ),
    );
  }

  static double? distanceMetersToBranch(
    Branch branch, {
    required double? userLat,
    required double? userLng,
  }) {
    if (userLat == null ||
        userLng == null ||
        branch.lat == null ||
        branch.lng == null) {
      return null;
    }
    return Geolocator.distanceBetween(
      userLat,
      userLng,
      branch.lat!,
      branch.lng!,
    );
  }

  /// When location is available, nearest branch first (lowest distance).
  static List<Branch> sortNearestFirst(
    List<Branch> branches, {
    required double? userLat,
    required double? userLng,
  }) {
    if (userLat == null || userLng == null) {
      return branches;
    }
    final sorted = List<Branch>.from(branches);
    sorted.sort((a, b) {
      final da = distanceMetersToBranch(a, userLat: userLat, userLng: userLng);
      final db = distanceMetersToBranch(b, userLat: userLat, userLng: userLng);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });
    return sorted;
  }

  static String distanceLabel(
    Branch branch, {
    required double? userLat,
    required double? userLng,
  }) {
    final meters = distanceMetersToBranch(
      branch,
      userLat: userLat,
      userLng: userLng,
    );
    if (meters == null) {
      return branch.distance.isEmpty ? '-' : branch.distance;
    }
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
