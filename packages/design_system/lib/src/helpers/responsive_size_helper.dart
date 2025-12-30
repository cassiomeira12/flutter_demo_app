import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class ResponsiveSizeHelper {
  // https://yesviz.com/viewport/

  // iPhone 12 mini 360 x 780
  static const double _viewPortReferenceWidth = 360;
  static const double _viewPortReferenceHeight = 780;

  // iPhone 12 390 x 844
  static const double maxWidth = 390;
  static const double maxHeight = 844;

  // iPhone 5 320 x 568
  static const double minWidth = 320;
  static const double minHeight = 568;

  static double width(double size) {
    if (_width > maxWidth) {
      return (maxWidth / _viewPortReferenceWidth) * size;
    }
    if (_width < minWidth) {
      return (minWidth / _viewPortReferenceWidth) * size;
    }
    return (_width / _viewPortReferenceWidth) * size;
  }

  static double height(double size) {
    if (_height > maxHeight) {
      return (maxHeight / _viewPortReferenceHeight) * size;
    }
    if (_height < minHeight) {
      return (minHeight / _viewPortReferenceHeight) * size;
    }
    return (_height / _viewPortReferenceHeight) * size;
  }

  static MediaQueryData get mediaQuery => MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.single,
  );

  static Size get _physicalSize =>
      WidgetsBinding.instance.platformDispatcher.views.single.physicalSize;

  static double get _width => mediaQuery.size.width;

  static double get _height => mediaQuery.size.height;

  static double get appBarHeight {
    double height = kToolbarHeight + mediaQuery.padding.top;
    if (Platform.isAndroid) {
      height += mediaQuery.padding.top * .35;
    }
    return height;
  }

  static double get navigationBarHeight {
    double height = kBottomNavigationBarHeight + mediaQuery.padding.bottom;
    // if (Platform.isAndroid) {
    //   height += mediaQuery.padding.bottom * .35;
    // }
    return height;
  }

  static double get spacingDefaultWidth => width(12);

  static double get spacingDefaultHeight => height(12);

  static String toStringSize() {
    return 'Device Physical Size \n'
        'width: ${_physicalSize.width.toInt()} px \n'
        'height: ${_physicalSize.height.toInt()} px \n'
        'devicePixelRatio: ${mediaQuery.devicePixelRatio} \n'
        '\n'
        'Device Size \n'
        'width: ${_width.toInt()} px \n'
        'height: ${_height.toInt()} px';
  }
}
