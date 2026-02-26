import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:force_update/src/presentation/presentation.dart';

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
      page: UpdatePage.new,
      binding: UpdateBindings(),
    ),
    AppRouterPage(
      name: AppRouter.forceUpdate.name,
      page: ForceUpdatePage.new,
      binding: UpdateBindings(),
    ),
  ];
}
