import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/app/app.dart';
import 'package:flutter_demo_app/translations/translation.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    PlatformDispatcher.instance.onError = (error, stack) {
      _catchFlutterExceptions(error, stack);
      return true;
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      // FlutterError.presentError(details);
      _catchFlutterExceptions(details.exception, details.stack);
    };

    BaseController.SPLASH_ALREADY_EXECUTED = false;
    AppTranslation.initLocales();
    ThemeManager.instance.defineColor();

    // debugPaintTextLayoutBoxes = true;
    // debugPaintSizeEnabled = true;
    // debugRepaintTextRainbowEnabled = true;

    await ResponsiveSizeHelper.initializeFlutterView();

    runApp(const App());
  }, _catchFlutterExceptions);
}

void _catchFlutterExceptions(Object error, StackTrace? stack) {
  final bool memoryError = error.toString().contains('memory');
  final bool disposeError = error.toString().contains('dispose');
  if (memoryError || disposeError) {
    Log.fatalError('potential memory leak', error: error, stackTrace: stack);
    return;
  }
  Log.fatalError('catchFlutterExceptions', error: error, stackTrace: stack);
}
