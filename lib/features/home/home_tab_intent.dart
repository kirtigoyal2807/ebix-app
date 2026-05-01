import 'package:flutter/foundation.dart';

/// Set to a bottom-nav index (e.g. `0` for Home) before navigating back to
/// [HomeView] so the shell can switch tabs after nested flows (e.g. receipt).
final ValueNotifier<int?> homeTabIntent = ValueNotifier<int?>(null);
