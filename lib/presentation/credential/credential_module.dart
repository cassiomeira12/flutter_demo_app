import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/credential/credential_bindings.dart';
import 'package:flutter_demo_app/presentation/credential/credential_page.dart';

class CredentialModule implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.credential.name,
      page: CredentialPage.new,
      binding: CredentialBindings(),
    ),
  ];
}
