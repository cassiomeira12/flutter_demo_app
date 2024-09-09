import 'package:get/get.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';
import '../app_bindings.dart';
import '../app_router.dart';

class SplashController extends BaseController {
  @override
  Future<void> onReady() async {
    super.onReady();
    String baseUrl = const String.fromEnvironment('base_url');

    Get.put<EnvironmentEntity>(
      EnvironmentEntity(
        baseUrl: baseUrl,
      ),
      permanent: true,
    );

    AppBindings().dependencies();

    await Future.delayed(const Duration(seconds: 2));

    Get.offAllNamed(
      AppRouter.home.route,
      arguments: 1,
    );
  }
}
