import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';

class CheckPointsModule implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.checkPoints.name,
      page: () => const CheckPointsPage(),
      binding: CheckPointsBindings(),
      children: [
        ...CheckPointModule().pages,
      ],
    ),
  ];
}
