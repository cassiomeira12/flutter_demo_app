import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UpdateController extends BaseController {
  final AppInfoEntity _appInfoEntity;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  UpdateController({
    required AppInfoEntity appInfoEntity,
    required OpenWebUrlUseCase openWebUrlUseCase,
  }) : _appInfoEntity = appInfoEntity,
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

  void updateNow() {
    clickTagging(component: 'update_now_button_key');
    late String url;
    const serverUrl = String.fromEnvironment('server_url');
    switch (Platform.currentPlatform) {
      case TargetPlatform.android:
        url = '$serverUrl/download_android_app';
      case TargetPlatform.iOS:
        url = '$serverUrl/download_ios_app';
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
        url = const String.fromEnvironment('web_app_url');
    }
    _openWebUrlUseCase.call(url);
  }
}
