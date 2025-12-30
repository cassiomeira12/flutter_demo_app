import 'package:core/core.dart';

import 'presentation/presentation.dart';

class UserAccountModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.deleteAccount.name,
      page: DeleteAccountPage.new,
      binding: DeleteAccountBindings(),
    ),
    AppRouterPage(
      name: AppRouter.deleteAccountConfirmation.name,
      page: DeleteAccountConfirmationPage.new,
      binding: DeleteAccountConfirmationBindings(),
    ),
    AppRouterPage(
      name: AppRouter.deleteAccountFinish.name,
      page: DeleteAccountFinishPage.new,
      binding: DeleteAccountFinishBindings(),
    ),
    AppRouterPage(
      popGesture: false,
      name: AppRouter.deleteAccountFinished.name,
      page: DeleteAccountFinishedPage.new,
      binding: DeleteAccountFinishedBindings(),
    ),
  ];
}
