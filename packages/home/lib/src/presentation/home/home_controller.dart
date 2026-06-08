import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class HomeController extends LifecycleController {
  final CheckInternetConnectionUseCase _checkInternetUseCase;

  HomeController({required this._checkInternetUseCase});

  RxnInt selectedIndex = BaseController.navigatorIndex;

  StreamSubscription<bool>? _internetConnectionSubscription;

  void changeTab(int index, String? key) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    clickTagging(
      route: AppNavigator.currentRoute,
      component: key ?? 'home_bottom_navigator_${index}_key',
    );
  }

  void onInternetConnectionChanged(bool isConnected) {
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
    _internetConnectionSubscription = _checkInternetUseCase.internetStream
        .listen(onInternetConnectionChanged);
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
    _internetConnectionSubscription?.resume();
  }

  @override
  void onAppBackground() {
    _internetConnectionSubscription?.pause();
  }

  @override
  void onClose() {
    _internetConnectionSubscription?.cancel();
    _checkInternetUseCase.dispose();
    super.onClose();
  }
}
