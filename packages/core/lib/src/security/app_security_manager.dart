import 'package:dependency/dependency.dart';

abstract class AppSecurityManager {
  static RxBool enableBlur = RxBool(false);

  bool get biometricsEnabled;
  bool get useBlurProtect;

  Future<void> init();

  Future<void> checkIfNeedBlockApp();

  void unlockApp();

  Future<void> clearSettings();
}
