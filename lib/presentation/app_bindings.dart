import 'package:flutter/services.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../design_system/design_system.dart';
import '../domain/domain.dart';
import '../infra/infra.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<MethodChannel>(
      MethodChannel('flutter'),
      permanent: true,
    );

    AppBinding.put<MainListener>(
      MainListener(methodChannel: Get.find(), listeners: []),
      permanent: true,
    );

    AppBinding.put<ILocalStorageUseCase>(
      LocalStorageUseCase(),
      permanent: true,
    );

    AppBinding.put<EnvironmentEntity>(
      EnvironmentEntity(
        appName: '',
        appId: '',
        clientKey: '',
        restApiKey: '',
        serverUrl: '',
        graphqllUrl: '',
      ),
      permanent: true,
    );

    AppBinding.put<Http>(
      HttpClient(
        environment: Get.find(),
        interceptors: [
          // CacheInterceptor(localStorage: Get.find()),
        ],
      ),
      permanent: true,
    );

    AppBinding.put<ThemeController>(
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

    AppBinding.putAsync<SessionEntity>(() async {
      final localStorage = Get.find<ILocalStorageUseCase>();
      String? token = await localStorage.get<String?>('token');
      print(token);
      return SessionEntity(token: null);
    });
  }
}
