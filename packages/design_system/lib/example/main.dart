import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/example/example.dart';

class DesignSystemExample extends StatelessWidget {
  const DesignSystemExample({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeManager.instance.lightTheme,
      // darkTheme: ThemeManager.instance.darkTheme,
      themeMode: ThemeManager.instance.themeMode,
      locale: PlatformDispatcher.instance.locale,
      fallbackLocale: Translation.fallbackLocale,
      supportedLocales: Translation.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/example',
      routes: routes,
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
