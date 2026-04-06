import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/app/app.dart';
import 'package:flutter_demo_app/translations/translation.dart';

void main() {
  CrashlyticsService.zonedGuarded(() async {
    CrashlyticsService.ensureInitialized();

    FlutterError.onError = CrashlyticsService.catchFlutterError;
    PlatformDispatcher.instance.onError = CrashlyticsService.catchException;

    AppTranslation.initLocales();
    ThemeManager.instance.defineColor();
    BaseController.SPLASH_ALREADY_EXECUTED = false;

    // debugPaintSizeEnabled = true;
    // debugPaintTextLayoutBoxes = true;
    // debugRepaintTextRainbowEnabled = true;

    await PerformanceMetricUseCase.call(
      name: 'initialize-flutter-view-performance-tracking',
      builder: (_) => ResponsiveSizeHelper.initializeFlutterView(),
    );

    runApp(CrashlyticsService.wrapperWidget(const App()));
  });
}
