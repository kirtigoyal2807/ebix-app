import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Device network reachability (Wi‑Fi / mobile data). Does not guarantee API access.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return hasConnectionForResults(results);
  }

  Stream<bool> get connectionStream =>
      _connectivity.onConnectivityChanged.map(hasConnectionForResults);

  @visibleForTesting
  static bool hasConnectionForResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }
}
