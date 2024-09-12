// ignore_for_file: deprecated_member_use

import '../design_system.dart';

abstract class ResponsiveSizeHelper {
  static const double _referenceWidth = 375;
  static const double _referenceHeight = 812;

  static const double _maxWidth = 500;
  static const double _maxHeight = 812;

  static double width(double size) {
    if (_width > _maxWidth) {
      return (_maxWidth / _referenceWidth) * size;
    }
    return (_width / _referenceWidth) * size;
  }

  static double height(double size) {
    if (_height > _maxHeight) {
      return (_maxHeight / _referenceHeight) * size;
    }
    return (_height / _referenceHeight) * size;
  }

  static MediaQueryData get mediaQuery =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  static double get _width => mediaQuery.size.width;

  static double get _height => mediaQuery.size.height;
}
