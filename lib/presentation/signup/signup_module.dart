import '../../core/core.dart';
import '../app_router.dart';
import 'signup_bindings.dart';
import 'signup_page.dart';

abstract class SignUpModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.signup.name,
      page: () => SignUpPage(),
      binding: SignUpBindings(),
    ),
  ];
}
