// ignore_for_file: no_default_cases

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UpdateController extends BaseController {
  final AppInfoEntity _appInfoEntity;
  final GetDeviceLocaleUseCase _currentDeviceLocaleUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  UpdateController({
    required AppInfoEntity appInfoEntity,
    required GetDeviceLocaleUseCase currentDeviceLocaleUseCase,
    required OpenWebUrlUseCase openWebUrlUseCase,
  }) : _appInfoEntity = appInfoEntity,
       _currentDeviceLocaleUseCase = currentDeviceLocaleUseCase,
       _openWebUrlUseCase = openWebUrlUseCase;

  RxString currentVersion = RxString('');

  @override
  void onReady() {
    super.onReady();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    currentVersion.value = _appInfoEntity.version;
  }

  Future<void> updateNow() async {
    clickTagging(component: 'update_now_button_key');

    final bool downloadFromStore = await _getFeatureFlagValue(
      RemoteFlagsEnum.downloadAndroidStore,
    );

    late String url;

    if (downloadFromStore) {
      switch (Platform.currentPlatform) {
        case TargetPlatform.android:
          const androidPackageName = String.fromEnvironment(
            'android_package_name',
          );
          final locale = await _currentDeviceLocaleUseCase.call();
          final currentLanguage = locale.toLanguageTag();
          url =
              'https://play.google.com/store/apps/details?id=$androidPackageName&hl=$currentLanguage';
        case TargetPlatform.iOS:
          const appAppleId = String.fromEnvironment('apple_store_app_id');
          url = 'https://apps.apple.com/br/app/$appAppleId';
        default:
          url = const String.fromEnvironment('web_app_url');
      }
    } else {
      const serverUrl = String.fromEnvironment('server_url');
      switch (Platform.currentPlatform) {
        case TargetPlatform.android:
          url = '$serverUrl/download_android_app';
        case TargetPlatform.iOS:
          url = '$serverUrl/download_ios_app';
        default:
          url = const String.fromEnvironment('web_app_url');
      }
    }

    _openWebUrlUseCase.call(url);
  }

  Future<bool> _getFeatureFlagValue(RemoteFlagsEnum flag) async {
    final RemoteFlag? featureFlag = await FeatureFlagServiceManager.instance
        .getFlag(flag);
    if (featureFlag?.isEnabled ?? false) {
      return featureFlag?.value == 'true';
    }
    return false;
  }
}
