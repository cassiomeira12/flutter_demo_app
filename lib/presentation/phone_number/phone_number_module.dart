import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/phone_number/phone_number_bindings.dart';
import 'package:flutter_demo_app/presentation/phone_number/phone_number_page.dart';

abstract class PhoneNumberModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.phoneNumber.name,
      page: () => PhoneNumberPage(),
      binding: PhoneNumberBindings(),
    ),
  ];
}
