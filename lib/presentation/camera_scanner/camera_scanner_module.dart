import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/camera_scanner/camera_scanner.dart';

abstract class CameraScannerModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.cameraScanner.name,
      page: CameraScannerPage.new,
      binding: CameraScannerBindings(),
    ),
  ];
}
