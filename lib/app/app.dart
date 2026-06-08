import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/app/app_module.dart';
import 'package:flutter_demo_app/translations/translation.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    AppRoutes.addRoutes(AppModule.routes);
    AppModule.setupHomePages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeManager.instance.lightTheme,
      darkTheme: ThemeManager.instance.darkTheme,
      themeMode: ThemeManager.instance.themeMode,
      initialRoute: AppRouter.initial.name,
      getPages: AppRoutes.routes.values.map((route) {
        return route.copy(
          middlewares: [
            SplashMiddleware(),
            RouterMiddleware(),
            ...route.middlewares ?? [],
          ],
        );
      }).toList(),
      translations: AppTranslation(),
      locale: PlatformDispatcher.instance.locale,
      fallbackLocale: Translation.fallbackLocale,
      supportedLocales: Translation.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [
        AppMemoryObserver(),
        if (!kDebugMode) CrashlyticsObserver(),
      ],
      onUnknownRoute: (settings) {
        return GetPageRoute(
          routeName: AppRouter.unknown.name,
          page: UnknownPage.new,
          binding: UnknownBindings(),
        );
      },
    );
  }
}
