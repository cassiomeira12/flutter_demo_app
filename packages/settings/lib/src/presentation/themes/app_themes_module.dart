import 'package:core/core.dart';
import 'package:settings/src/presentation/themes/app_themes.dart';

class AppThemesModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.themes.name,
      page: AppThemesPage.new,
      binding: AppThemesBindings(),
    ),
  ];
}
