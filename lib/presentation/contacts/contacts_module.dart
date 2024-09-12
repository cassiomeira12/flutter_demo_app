import 'package:get/get.dart';

import '../app_router.dart';
import 'contacts_bindings.dart';
import 'contacts_page.dart';

abstract class ContactsModule {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouter.contacts.name,
      page: () => ContactsPage(),
      binding: ContactsBindings(),
      preventDuplicates: false,
    ),
  ];
}
