import 'package:flutter_demo_app/core/core.dart';

import '../app_router.dart';

class LoginController extends BaseController {
  void login() {
    AppRouter.offAndToNamed(AppRouter.home);
  }
}
