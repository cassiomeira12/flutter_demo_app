import '../core/core.dart';
import 'app_router.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'middlewares/middlewares.dart';
import 'recovery_password/recovery_password.dart';
import 'signup/signup.dart';
import 'splash/spash.dart';

abstract class AppModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.splash.name,
      page: () => SplashPage(),
      binding: SplashBindings(),
    ),
    AppRouterPage(
      name: AppRouter.login.name,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
    AppRouterPage(
      name: AppRouter.recoveryPassword.name,
      page: () => RecoveryPasswordPage(),
      binding: RecoveryPasswordBindings(),
    ),
    AppRouterPage(
      name: AppRouter.signup.name,
      page: () => SignUpPage(),
      binding: SignUpBindings(),
    ),
    AppRouterPage(
      name: AppRouter.home.name,
      page: () => HomePage(),
      binding: HomeBindings(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
  ];
}
