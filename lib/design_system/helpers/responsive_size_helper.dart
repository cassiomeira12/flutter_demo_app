// ignore_for_file: deprecated_member_use

import '../design_system.dart';

class ResponsiveSizeHelper {
  static const double referenceWith = 375;
  static const double referenceHeight = 812;

  static double width(double size) {
    return (_width / referenceWith) * size;
  }

  static double height(double size) {
    return (_height / referenceHeight) * size;
  }

  static MediaQueryData get _mediaQuery =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  static double get _width => _mediaQuery.size.width;

  static double get _height => _mediaQuery.size.height;
}
