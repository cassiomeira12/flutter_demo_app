import 'package:core/core.dart' show AppRouter, AppRouterPage;
import 'package:flutter_demo_app/presentation/new_contact/new_contact_bindings.dart';
import 'package:flutter_demo_app/presentation/new_contact/new_contact_page.dart';

abstract class NewContactModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.newContact.name,
      page: NewContactPage.new,
      binding: NewContactBindings(),
    ),
  ];
}
