import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AdminController extends BaseController {
  // final IGetUserDataUseCase _getUserDataUseCase;
  // final IOpenWebUrlUseCase _openWebUrlUseCase;
  final LogoutUseCase _logoutUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final PushMessagingService _pushMessagingService;
  final AppSecurityManager _appSecurityManager;

  AdminController({
    //required IGetUserDataUseCase getUserDataUseCase,
    //required IOpenWebUrlUseCase openWebUrlUseCase,
    required LogoutUseCase logoutUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required PushMessagingService pushMessagingService,
    required AppSecurityManager appSecurityManager,
  }) : _logoutUseCase = logoutUseCase,
       _localStorageUseCase = localStorageUseCase,
       _pushMessagingService = pushMessagingService,
       _appSecurityManager = appSecurityManager;

  final EnvironmentEntity environment = AppBinding.find<EnvironmentEntity>();
  final UserEntity user = AppBinding.find<UserEntity>();

  RxnInt selectedIndex = BaseController.navigatorIndex;

  @override
  void backPage({
    dynamic result,
    bool ignoreId = false,
    bool? onlyPopStackRouter,
  }) {
    if (Platform.isWeb) {
      DialogWidget.showChoice(
        Get.context!,
        title: 'logout'.tr,
        message: 'logout_app_message'.tr,
        okButton: 'logout'.tr,
      ).then((result) {
        if (result == true) {
          AppNavigator.backAllAndToNamed(AppRouter.splash);
        }
      });
      return;
    }
    super.backPage(result: result);
  }

  void changeTab(int index, String? key) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    clickTagging(
      route: AppNavigator.currentRoute,
      component: key ?? 'drawer_admin_bottom_menu_$index',
    );
  }

  Future<void> logout() async {
    try {
      clickTagging(component: 'logout_drawer_item_key');
      logoutTagging();
      await _logoutUseCase.call();
    } catch (_) {
    } finally {
      await _appSecurityManager.clearSettings();
      await _appSecurityManager.init();
      _appSecurityManager.unlockApp();
      await SessionHelper.clear();
      AppNavigator.backAllAndToNamed(AppRouter.splash);
    }
  }
}
