import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';

class WorkPointOnClickedNotificationCallback
    extends OnClickedNotificationCallbackBase {
  @override
  Future<void> onClicked(Map<String, dynamic> map) async {
    final String? action = map['data']['action'];

    if (action == 'register-work-point') {
      int tentativas = 10;
      while (!AppNavigator.currentRoute.contains(AppRouter.checkPoint.name)) {
        if (tentativas < 0) {
          return;
        }
        await Future.delayed(const Duration(seconds: 1));
        tentativas--;
      }
      try {
        await Future.delayed(const Duration(seconds: 1));
        await AppBinding.find<CheckPointsController>().registerPoint();
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
      return;
    }

    return super.onClicked(map);
  }
}
