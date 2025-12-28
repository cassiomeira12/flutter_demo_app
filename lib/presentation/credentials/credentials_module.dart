import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/credential/credential.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';

abstract class CredentialsModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.credentials.name,
      page: CredentialsPage.new,
      binding: CredentialsBindings(),
      children: [
        ...CredentialModule.pages,
      ],
    ),
  ];
}
