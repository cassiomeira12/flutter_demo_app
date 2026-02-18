import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:onboarding/src/presentation/intro/intro.dart';

class OnboardingModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.intro.name,
      page: () => const IntroPage(),
      binding: IntroBindings(),
      transition: Transition.noTransition,
    ),
  ];
}
