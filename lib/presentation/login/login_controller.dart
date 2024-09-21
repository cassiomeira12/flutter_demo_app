import 'package:flutter_demo_app/core/core.dart';

import '../../domain/domain.dart';
import '../app_router.dart';

class LoginController extends BaseController {
  final ILocalStorageUseCase _localStorage;

  LoginController({
    required ILocalStorageUseCase localStorage,
  }) : _localStorage = localStorage;

  void login() {
    var token = SessionEntity(token: '1234');

    _localStorage.set('token', token.token);

    Get.put<SessionEntity>(
      token,
      permanent: true,
    );

    AppRouter.backAllAndToNamed(AppRouter.home);
  }

  void signUp() {
    AppRouter.toNamed(AppRouter.signup);
  }

  void recoveryPassword() {
    AppRouter.toNamed(AppRouter.recoveryPassword);
  }
}
