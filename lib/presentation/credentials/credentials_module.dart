import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';

class CredentialsModule implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.credentials.name,
      page: CredentialsPage.new,
      binding: CredentialsBindings(),
    ),
  ];
}
