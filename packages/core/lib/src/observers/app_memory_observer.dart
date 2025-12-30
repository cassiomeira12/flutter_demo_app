import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppMemoryObserver extends NavigatorObserver {
  void appMemoryUsage() {
    if (Platform.isWeb) return;
    final double maxMemory = ProcessInfo.maxRss / 1024 / 1024;
    final double memoryUsed = ProcessInfo.currentRss / 1024 / 1024;
    final String message =
        'Current memory usage: ${memoryUsed.toStringAsFixed(2)}MB / ${maxMemory.toStringAsFixed(2)}MB';
    Log.info(message);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    appMemoryUsage();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    appMemoryUsage();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    appMemoryUsage();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    appMemoryUsage();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
