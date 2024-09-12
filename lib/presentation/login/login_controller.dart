import 'package:flutter_demo_app/core/core.dart';
import 'package:get/get.dart';

import '../../domain/domain.dart';
import '../app_router.dart';

class LoginController extends BaseController {
  void login() {
    Get.put<SessionEntity>(
      SessionEntity(
        token: '',
      ),
      permanent: true,
    );

    AppRouter.offAndToNamed(AppRouter.home);
  }
}
