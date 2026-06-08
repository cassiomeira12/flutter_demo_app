import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/camera_scanner/camera_scanner.dart';

class CameraScannerModule implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.cameraScanner.name,
      page: CameraScannerPage.new,
      binding: CameraScannerBindings(),
    ),
  ];
}
