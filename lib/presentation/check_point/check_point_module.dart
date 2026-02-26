import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_bindings.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_page.dart';

class CheckPointModule implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.checkPoint.name,
      page: () => const CheckPointPage(),
      binding: CheckPointBindings(),
    ),
  ];
}
