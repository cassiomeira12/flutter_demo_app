import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../design_system/design_system.dart';
import '../domain/domain.dart';
import '../infra/infra.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MethodChannel>(
      MethodChannel('flutter'),
      permanent: true,
    );
    Get.put<MainListener>(
      MainListener(methodChannel: Get.find(), listeners: []),
      permanent: true,
    );

    Get.put<ILocalStorageUseCase>(
      LocalStorageUseCase(),
      permanent: true,
    );
    Get.put<Http>(
      HttpClient(
        environment: Get.find(),
        interceptors: [
          // CacheInterceptor(localStorage: Get.find()),
        ],
      ),
      permanent: true,
    );
    Get.put<ThemeController>(
      ThemeController(
        setThemData: (theme) {
          Get.changeTheme(theme);
          Get.forceAppUpdate();
        },
        setThemMode: (mode) {
          // Get.find<AppController>().currentThemeMode.value = describeEnum(mode);
          Get.changeThemeMode(mode);
          Get.forceAppUpdate();
        },
      ),
      permanent: true,
    );
  }
}
