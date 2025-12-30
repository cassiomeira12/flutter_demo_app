import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UpdateController extends BaseController {
  final AppInfoEntity _appInfoEntity;
  final LocalStorageUseCase _localStorageUseCase;
  final FeatureFlagService _featureFlagService;
  final PushMessagingService _pushMessagingService;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  UpdateController({
    required AppInfoEntity appInfoEntity,
    required LocalStorageUseCase localStorageUseCase,
    required FeatureFlagService featureFlagService,
    required PushMessagingService pushMessagingService,
    required OpenWebUrlUseCase openWebUrlUseCase,
  }) : _appInfoEntity = appInfoEntity,
       _localStorageUseCase = localStorageUseCase,
       _featureFlagService = featureFlagService,
       _pushMessagingService = pushMessagingService,
       _openWebUrlUseCase = openWebUrlUseCase;

  RxString currentVersion = RxString('');
  RxString newVersion = RxString('');
  RxString news = RxString('');
  RxString improvements = RxString('');
  RxString fixes = RxString('');
  RxBool requiredUpdate = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _getAppInfo();
    _unsubscribeOldAppVersion();
  }

  Future<void> _getAppInfo() async {
    currentVersion.value = _appInfoEntity.version;

    final RemoteFlag? updateAppDataFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateAppData,
      reload: true,
    );

    try {
      final Map<String, dynamic> json = jsonDecode(
        updateAppDataFlag?.value ?? '',
      );
      newVersion.value = json['new_version'];
      news.value = List.from(
        json['news'] ?? [],
      ).map((item) => '> $item').join('\n');
      improvements.value = List.from(
        json['improvements'] ?? [],
      ).map((item) => '> $item').join('\n');
      fixes.value = List.from(
        json['fixes'] ?? [],
      ).map((item) => '> $item').join('\n');
    } catch (_) {}

    final RemoteFlag? requiredUpdateFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateAppRequired,
      reload: true,
    );

    final bool mustRequiredUpdate =
        requiredUpdateFlag?.isEnabled == true &&
        requiredUpdateFlag?.value == 'true';

    requiredUpdate.value = mustRequiredUpdate;
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

  Future<void> _unsubscribeOldAppVersion() async {
    final String packageName = _appInfoEntity.packageName;
    final String currentVersion = _appInfoEntity.version;
    final String? oldVersionApp = await _localStorageUseCase.get<String>(
      CURRENT_APP_VERSION,
    );

    if (oldVersionApp != null && currentVersion != oldVersionApp) {
      final String oldTopicVersion = '${packageName}_$oldVersionApp';
      await _pushMessagingService.unsubscribeTopic(oldTopicVersion);
      await _localStorageUseCase.set<String>(
        CURRENT_APP_VERSION,
        currentVersion,
      );
    }
  }
}
