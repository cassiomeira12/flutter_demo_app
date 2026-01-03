import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/app/app.dart';
import 'package:flutter_demo_app/app/themes/custom_app_themes.dart';
import 'package:flutter_demo_app/translations/translation.dart';

void main() {
  CrashlyticsService.zonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = CrashlyticsService.catchFlutterError;
    PlatformDispatcher.instance.onError = CrashlyticsService.catchException;

    AppTranslation.initLocales();
    final Color primaryEnvColor = ThemeManager.primaryEnvColor;
    ThemeManager.instance.defineColor(
      lightColorScheme: WebViewLightColorScheme(color: primaryEnvColor),
      darkColorScheme: WebViewDarkColorScheme(color: primaryEnvColor),
    );
    BaseController.SPLASH_ALREADY_EXECUTED = false;

    // debugPaintSizeEnabled = true;
    // debugPaintTextLayoutBoxes = true;
    // debugRepaintTextRainbowEnabled = true;

    await PerformanceMetricUseCase.call(
      name: 'initialize-flutter-view-performance-tracking',
      builder: (_) => ResponsiveSizeHelper.initializeFlutterView(),
    );

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return ErrorPage(errorDetails: errorDetails);
    };

    runApp(CrashlyticsService.wrapperWidget(const App()));
  });
}
