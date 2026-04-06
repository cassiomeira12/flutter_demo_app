import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BaseController extends GetxController with AnalyticsMixin {
  static bool SPLASH_ALREADY_EXECUTED = false;

  final String pageRouteNamed = AppNavigator.currentRoute;

  static RxnInt navigatorIndex = RxnInt();

  int? get navigatorIndexValue {
    return navigatorIndex.value;
  }

  bool _buildContextSet = false;
  late BuildContext _currentContext;
  BuildContext get context => _currentContext;

  @override
  void onInit() {
    setOrientationPortraitOnly();
    super.onInit();
  }

  @override
  void onReady() {
    screenTagging();
    super.onReady();
  }

  @override
  void onClose() {
    backTagging();
    super.onClose();
  }

  void setPageContext(BuildContext context) {
    if (_buildContextSet) return;
    _currentContext = context;
    onReadyPage(context);
    _buildContextSet = true;
  }

  void onReadyPage(BuildContext context) {
    if (_buildContextSet) return;
    _currentContext = context;
  }

  void setOrientationPortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setOrientationLandscapeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setOrientationRotate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void openNotifications() {
    clickTagging(component: 'notifications_bell_icon_key');
    AppNavigator.toNamed(AppRouter.notifications);
  }

  void backPage({dynamic result}) {
    AppNavigator.back(result: result);
  }

  @override
  void screenTagging({String? route}) {
    super.screenTagging(route: route ?? pageRouteNamed);
  }

  @override
  void clickTagging({String? route, String? component}) {
    super.clickTagging(route: route ?? pageRouteNamed, component: component);
  }

  @override
  void backTagging({String? route}) {
    super.backTagging(route: route ?? pageRouteNamed);
  }

  @override
  void callbackTagging({String? route}) {
    super.callbackTagging(route: route ?? pageRouteNamed);
  }
}
