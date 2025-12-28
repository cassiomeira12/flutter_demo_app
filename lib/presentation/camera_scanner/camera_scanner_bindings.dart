import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/camera_scanner/camera_scanner.dart';

class CameraScannerBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CameraScannerController>(
      CameraScannerController(),
    );
  }
}
