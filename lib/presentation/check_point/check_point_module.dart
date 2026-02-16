import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_bindings.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_page.dart';

abstract class CheckPointModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.checkPoint.name,
      page: () => const CheckPointPage(),
      binding: AboutBindings(),
    ),
  ];
}
