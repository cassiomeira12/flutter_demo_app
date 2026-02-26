import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/app/app.dart';
import 'package:flutter_demo_app/translations/translation.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = CrashlyticsService.catchFlutterError;
    PlatformDispatcher.instance.onError = CrashlyticsService.catchException;

    AppTranslation.initLocales();
    ThemeManager.instance.defineColor();
    BaseController.SPLASH_ALREADY_EXECUTED = false;

    // debugPaintTextLayoutBoxes = true;
    // debugPaintSizeEnabled = true;
    // debugRepaintTextRainbowEnabled = true;

    await ResponsiveSizeHelper.initializeFlutterView();

    runApp(const App());
  }, CrashlyticsService.catchException);
}
