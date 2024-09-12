import 'package:get/get.dart';

import 'contacts_controller.dart';

class ContactsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ContactsController>(
      ContactsController(),
    );
  }
}
