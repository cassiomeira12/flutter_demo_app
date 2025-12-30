import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class HomeController extends LifecycleController {
  final CheckInternetConnectionUseCase _checkInternetUseCase;

  HomeController({required CheckInternetConnectionUseCase checkInternetUseCase})
    : _checkInternetUseCase = checkInternetUseCase;

  RxnInt selectedIndex = BaseController.navigatorIndex;

  Stream<bool>? _internetConnectionStream;

  void changeTab(int index, String? key) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    clickTagging(
      route: AppNavigator.currentRoute,
      component: key ?? 'home_bottom_navigator_${index}_key',
    );
  }

  void internetConnectionListener(bool isConnected) {
    if (!isConnected) {
      // Get.showSnackbar(
      //   const GetSnackBar(
      //     title: 'Internet',
      //     message: 'Você está sem conexão com a internet',
      //     backgroundColor: AppColors.statusWarning,
      //     maxWidth: ResponsiveSizeHelper.maxWidth,
      //     duration: Duration(seconds: 1),
      //     snackStyle: SnackStyle.GROUNDED,
      //   ),
      // );
    }
  }

  @override
  void onReady() {
    super.onReady();
    refreshUnCountNotifications();
    _internetConnectionStream = _checkInternetUseCase.internetStream
        .asBroadcastStream();
    _internetConnectionStream?.listen(internetConnectionListener);
  }

  @override
  void backPage({
    dynamic result,
    bool ignoreId = false,
    bool? onlyPopStackRouter,
  }) {
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
  }

  @override
  void onAppResumed() {
    _checkInternetUseCase.resumeStream();
  }

  @override
  void onAppBackground() {
    _checkInternetUseCase.pauseStream();
  }

  @override
  void onClose() {
    _checkInternetUseCase.dispose();
    super.onClose();
  }
}
