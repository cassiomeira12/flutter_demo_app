import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class IntroController extends BaseController {
  final RequestPermissionUseCase _requestPermissionUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;

  final PageController pageController = PageController();
  final RxInt indexPage = RxInt(0);
  RxBool get isLastPage {
    return RxBool(indexPage.value == pagesLength - 1);
  }

  int pagesLength = 0;
  Permission? currentPermission;

  IntroController({
    required RequestPermissionUseCase requestPermissionUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required GetAppInfoUseCase getAppInfoUseCase,
  }) : _requestPermissionUseCase = requestPermissionUseCase,
       _localStorageUseCase = localStorageUseCase,
       _getAppInfoUseCase = getAppInfoUseCase;

  @override
  void onReady() {
    super.onReady();
    onboardingBeginTagging();
    _checkIfHasNoIntroPages();
  }

  void _checkIfHasNoIntroPages() {
    if (pagesLength == 0) {
      _finishIntroPages();
      return;
    }
    _removeNativeSplashScreen();
  }

  void setPermission(Permission permission) {
    currentPermission = permission;
  }

  void previousPage() {
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
    final String currentVersion = CURRENT_APP_VERSION + appInfoEntity.version;
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

  void _removeNativeSplashScreen() {
    Future.delayed(
      const Duration(milliseconds: 500),
      FlutterNativeSplash.remove,
    );
  }
}
