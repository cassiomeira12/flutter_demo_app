import '../../core/core.dart';
import '../app_router.dart';
import 'recovery_password_bindings.dart';
import 'recovery_password_page.dart';

abstract class AboutModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.about.name,
      page: () => RecoveryPasswordPage(),
      binding: RecoveryPasswordBindings(),
      preventDuplicates: false,
    ),
  ];
}
