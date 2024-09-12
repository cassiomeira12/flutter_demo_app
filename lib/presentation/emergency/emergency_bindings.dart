import 'package:get/get.dart';

import 'emergency_controller.dart';

class EmergencyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<EmergencyController>(
      EmergencyController(),
    );
  }
}
