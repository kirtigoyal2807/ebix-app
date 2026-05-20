import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';

/// Shared look for every blocking load (Account tab, dialogs, forms, etc.).
abstract final class AppBlockingLoadStyle {
  /// Centered dark-brown [AppLoadingIndicator] — no per-screen variants.
  static const double spinnerSize = 36;

  /// No dim scrim by default (matches Account profile refresh).
  /// Pass [BlockingLoadingOverlay.scrimColor] only for special cases (e.g. web view).
  static Color? get defaultScrim => null;
}

/// Full-screen layer: [AbsorbPointer] + centered [AppLoadingIndicator].
/// **The only blocking loader for feature/UI code.**
class BlockingLoadingOverlay extends StatelessWidget {
  const BlockingLoadingOverlay({this.scrimColor});

  /// Override only when a mask is required (e.g. payment web view). Usually omit.
  final Color? scrimColor;

  @override
  Widget build(BuildContext context) {
    final effectiveScrim = scrimColor ?? AppBlockingLoadStyle.defaultScrim;

    Widget child = const AppLoadingIndicator(
      size: AppBlockingLoadStyle.spinnerSize,
    );
    final s = effectiveScrim;
    if (s != null) {
      child = ColoredBox(color: s, child: child);
    }
    return Positioned.fill(
      child: AbsorbPointer(child: child),
    );
  }
}

/// [Stack] wrapper — use for screen bodies while async work runs.
class BlockingLoadingStack extends StatelessWidget {
  const BlockingLoadingStack({
    super.key,
    required this.loading,
    required this.child,
    this.scrimColor,
    this.fit = StackFit.loose,
  });

  final bool loading;
  final Widget child;

  /// Usually omit so the loader matches the Account tab everywhere.
  final Color? scrimColor;
  final StackFit fit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: fit,
      children: [
        child,
        if (loading) BlockingLoadingOverlay(scrimColor: scrimColor),
      ],
    );
  }
}

/// Modal blocking load (e.g. payment prep).
Future<void> showBlockingLoadingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    useRootNavigator: true,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: MediaQuery.sizeOf(dialogContext).width,
          height: MediaQuery.sizeOf(dialogContext).height,
          child: const BlockingLoadingStack(
            fit: StackFit.expand,
            loading: true,
            child: SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );
}
