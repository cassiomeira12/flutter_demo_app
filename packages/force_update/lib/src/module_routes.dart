import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'presentation/presentation.dart';

class ForceUpdateModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      canPop: false,
      name: AppRouter.blocking.name,
      page: BlockingPage.new,
      binding: BlockingBindings(),
      transition: Transition.noTransition,
    ),
    AppRouterPage(
      name: AppRouter.update.name,
      page: () => const UpdatePage(),
      binding: UpdateBindings(),
    ),
    AppRouterPage(
      name: AppRouter.updated.name,
      page: () => const UpdatedPage(),
      binding: UpdateBindings(),
    ),
  ];
}
