import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AnalyticsServiceFaker implements AnalyticsService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {}
}
