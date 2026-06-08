import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class IntroController extends BaseController {
  final AppEnvironmentEntity _appEnv;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;

  IntroController({
    required this._appEnv,
    required this._requestPermissionUseCase,
    required this._localStorageUseCase,
    required this._getAppInfoUseCase,
  }) {
    isLastPage.value = indexPage.value == permissions.length;
    indexPage.addListener(_updateCurrentIndex);
  }

  final PageController pageController = PageController();
  final indexPage = ValueNotifier<int>(0);
  final isLastPage = ValueNotifier<bool>(false);

  Permission? currentPermission;
  String get appName => _appEnv.appName;

  List<String> get permissions {
    final List<String> permissions = List.from(_appEnv.permissions);
    if (!Platform.isIOS) {
      permissions.removeWhere((permission) {
        return permission == 'appTrackingTransparency';
      });
    }
    if (Platform.isMacOS) {
      permissions.removeWhere((permission) {
        return permission == 'notification';
      });
    }
    return permissions;
  }

  @override
  void onReady() {
    super.onReady();
    onboardingBeginTagging();
  }

  @override
  void onClose() {
    indexPage.removeListener(_updateCurrentIndex);
    indexPage.dispose();
    isLastPage.dispose();
    pageController.dispose();
    super.onClose();
  }

  void _updateCurrentIndex() {
    isLastPage.value = indexPage.value == permissions.length;
  }

  void setPermission(Permission permission) {
    currentPermission = permission;
  }

  void previousPage() {
    currentPermission = null;
    pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  Future<void> nextPage() async {
    await requestCurrentPermission();

    await pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  Future<void> requestCurrentPermission() async {
    await _requestPermission(currentPermission);

    if (isLastPage.value) {
      _finishIntroPages();
      return;
    }
  }

  Future<void> _finishIntroPages() async {
    await _localStorageUseCase.set<bool>(INTRO_DONE, true);
    await _setUpdatedAppFinished();
    AppNavigator.backAllAndToNamed(AppRouter.splash);
    onboardingCompleteTagging();
  }

  Future<void> _setUpdatedAppFinished() async {
    final AppInfoEntity appInfoEntity = await _getAppInfoUseCase.call();
    final String currentVersion =
        '${CURRENT_APP_VERSION}_${appInfoEntity.version}';
    await _localStorageUseCase.set<bool>(currentVersion, true);
  }

  Future<void> _requestPermission(Permission? permission) async {
    if (permission == null) return;
    switch (permission) {
      case Permission.appTrackingTransparency:
        return _requestAppTrackingPermission();
      case Permission.notification:
        return _requestNotificationsPermission();
      case Permission.location:
        return _requestLocationPermission();
    }
  }

  Future<void> _requestAppTrackingPermission() async {
    await _requestPermissionUseCase
        .call(Permission.appTrackingTransparency)
        .then((permission) {
          final bool accepted = permission.isGranted;
          AnalyticsMixin.eventTagging(
            'intro_permissions',
            parameters: {
              'permission': 'apptracking-${accepted ? 'accepted' : 'denied'}',
            },
          );
        });
  }

  Future<void> _requestNotificationsPermission() async {
    await _requestPermissionUseCase.call(Permission.notification).then((
      permission,
    ) {
      final bool accepted = permission.isGranted;
      AnalyticsMixin.eventTagging(
        'intro_permissions',
        parameters: {
          'permission': 'notification-${accepted ? 'accepted' : 'denied'}',
        },
      );
    });
  }

  Future<void> _requestLocationPermission() async {
    await _requestPermissionUseCase.call(Permission.location).then((
      permission,
    ) {
      final bool accepted = permission.isGranted;
      AnalyticsMixin.eventTagging(
        'intro_permissions',
        parameters: {
          'permission': 'location-${accepted ? 'accepted' : 'denied'}',
        },
      );
    });
  }
}
