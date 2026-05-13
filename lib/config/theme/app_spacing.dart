import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  /// Scales [designPx] with ScreenUtil. Not cached in static fields: on some
  /// Android devices the first read can occur before window metrics are ready,
  /// which would freeze [0.0] for the app lifetime if stored in a field.
  static double _scaled(double designPx) {
    final sw = ScreenUtil().screenWidth;
    return sw > 0 ? designPx.w : designPx;
  }

  static double get xs => _scaled(4.0);
  static double get xi => _scaled(6.0);
  static double get sm => _scaled(8.0);
  static double get base => _scaled(12.0);
  static double get md => _scaled(16.0);
  static double get lmd => _scaled(20.0);
  static double get lg => _scaled(24.0);
  static double get xl => _scaled(32.0);
  static double get xxl => _scaled(40.0);
  static double get xxxl => _scaled(48.0);
  static double get horizontalPadding => _scaled(24.0);
  static double get buttonHeight => _scaled(54.0);
}
