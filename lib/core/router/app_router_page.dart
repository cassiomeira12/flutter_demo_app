import 'package:get/get.dart';

class AppRouterPage<T> extends GetPage<T> {
  AppRouterPage({
    required super.name,
    required super.page,
    super.binding,
    super.bindings,
    super.middlewares,
    super.preventDuplicates,
    super.children,
  });
}
