import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/connectivity/connectivity_service.dart';
import 'package:pilates_app/features/auth/auth_root_view.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/connectivity/no_internet_view.dart';

/// Gates app entry on device connectivity. Offline users see [NoInternetView] only.
class AppBootstrapView extends StatefulWidget {
  const AppBootstrapView({
    super.key,
    ConnectivityService? connectivityService,
  }) : _connectivityService = connectivityService;

  final ConnectivityService? _connectivityService;

  @override
  State<AppBootstrapView> createState() => _AppBootstrapViewState();
}

class _AppBootstrapViewState extends State<AppBootstrapView> {
  late final ConnectivityService _connectivity =
      widget._connectivityService ?? ConnectivityService();

  /// `null` = initial check in progress.
  bool? _isOnline;
  bool _isCheckingRetry = false;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    unawaited(_runInitialCheck());
    _connectionSubscription = _connectivity.connectionStream.listen(
      _onConnectivityChanged,
    );
  }

  @override
  void dispose() {
    unawaited(_connectionSubscription?.cancel());
    super.dispose();
  }

  Future<void> _runInitialCheck() async {
    final online = await _connectivity.hasConnection();
    if (!mounted) return;
    _applyConnectivity(online, isInitial: true);
  }

  void _onConnectivityChanged(bool online) {
    if (!mounted) return;
    // Auto-continue when the user regains connectivity while on the offline screen.
    if (_isOnline == false && online) {
      _applyConnectivity(true, isInitial: false);
    }
  }

  void _applyConnectivity(bool online, {required bool isInitial}) {
    setState(() {
      _isOnline = online;
      _isCheckingRetry = false;
    });
    if (online) {
      context.read<AuthCubit>().onConnectivityReady();
    }
  }

  Future<void> _onTryAgain() async {
    if (_isCheckingRetry) return;
    setState(() => _isCheckingRetry = true);
    final online = await _connectivity.hasConnection();
    if (!mounted) return;
    if (online) {
      _applyConnectivity(true, isInitial: false);
    } else {
      setState(() => _isCheckingRetry = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isOnline == null) {
      return _BootstrapPlaceholder(
        isDark: Theme.of(context).brightness == Brightness.dark,
      );
    }

    if (_isOnline == false) {
      return NoInternetView(
        onTryAgain: _onTryAgain,
        isChecking: _isCheckingRetry,
      );
    }

    return const AuthRootView();
  }
}

/// Brief blank screen while the first connectivity check runs.
class _BootstrapPlaceholder extends StatelessWidget {
  const _BootstrapPlaceholder({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.offlineBackgroundDark : AppColors.whiteColor,
    );
  }
}
