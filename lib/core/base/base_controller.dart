import 'package:get/get.dart';

import 'analytics_mixin.dart';

class BaseController extends GetxController with AnalyticsMixin {
  late String _pageRoute;

  @override
  void onReady() {
    super.onReady();
    _pageRoute = Get.currentRoute;
    screenTagging();
    //AppRouter.home
  }

  void backPage() {
    backTagging();
    Get.back();
  }

  @override
  void screenTagging({String? route}) {
    super.screenTagging(route: _pageRoute);
  }

  @override
  void clickTagging({String? route}) {
    super.clickTagging(route: _pageRoute);
  }

  @override
  void backTagging({String? route}) {
    super.backTagging(route: _pageRoute);
  }

  @override
  void callbackTagging({String? route}) {
    super.callbackTagging(route: _pageRoute);
  }
}
