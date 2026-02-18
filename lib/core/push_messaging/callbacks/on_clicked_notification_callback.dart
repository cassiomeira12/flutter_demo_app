import 'package:core/core.dart';

class WorkPointOnClickedNotificationCallback
    implements OnClickedNotificationCallback {
  @override
  Future<void> onClicked(Map<String, dynamic> map) async {
    Log.success('$runtimeType \n $map');

    final String? action = map['data']['action'];

    switch (action) {
      case 'test_push_notification':
      case null:
    }
  }
}
