import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/contacts/contacts.dart';
import 'package:flutter_demo_app/presentation/new_contact/new_contact_module.dart';

abstract class ContactsModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.contacts.name,
      page: () => const ContactsPage(),
      binding: ContactsBindings(),
      children: [
        ...NewContactModule.pages,
        // ...NotificationsModule.routes,
      ],
    ),
  ];
}
