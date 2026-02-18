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

  static Future<void> initializeFlutterView() async {
    if (!kDebugMode && Platform.isAndroid) {
      final completer = Completer<void>();
      final oldOnMetricsChanged = PlatformDispatcher.instance.onMetricsChanged!;
      PlatformDispatcher.instance.onMetricsChanged = () {
        if (!completer.isCompleted) {
          final view = WidgetsBinding.instance.platformDispatcher.views.single;
          final mediaQuery = MediaQueryData.fromView(view);
          Log.info(
            'Device Physical Size \n'
            'width: ${view.physicalSize.width.toInt()} px \n'
            'height: ${view.physicalSize.height.toInt()} px \n'
            'devicePixelRatio: ${mediaQuery.devicePixelRatio} \n'
            '\n'
            'Device Size \n'
            'width: ${mediaQuery.size.width.toInt()} px \n'
            'height: ${mediaQuery.size.height.toInt()} px',
          );
          if (mediaQuery.size.width > 0 && mediaQuery.size.height > 0) {
            completer.complete(null);
          }
        }
        oldOnMetricsChanged();
      };
      return completer.future;
    }
  }

  static final FlutterView _view =
      WidgetsBinding.instance.platformDispatcher.views.single;
  static final MediaQueryData mediaQuery = MediaQueryData.fromView(_view);

  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;

  static double get spacingDefaultWidth => width(12);
  static double get spacingDefaultHeight => height(12);

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

  static double get appBarHeight {
    double height = kToolbarHeight + mediaQuery.padding.top;
    if (Platform.isAndroid) {
      height += mediaQuery.padding.top * .35;
    }
    return height;
  }

  static double get navigationBarHeight {
    final double height =
        kBottomNavigationBarHeight + mediaQuery.padding.bottom;
    // if (Platform.isAndroid) {
    //   height += mediaQuery.padding.bottom * .35;
    // }
    return height;
  }
}
