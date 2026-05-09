import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AnalyticsServiceFaker implements AnalyticsService {
  @override
  Future<void> init() async {}

  @override
  Future<void> setUserId(String? userId) async {
    if (!Log.isIntegrationTest) {
      Log.info('userId: $userId');
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {
    if (!Log.isIntegrationTest) {
      Log.info(
        'Event: $name \n'
        'Parameters: $property',
      );
    }
  }

  @override
  Future<void> logEvent(
    String event, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!Log.isIntegrationTest) {
      Log.info(
        'Event: $event \n'
        'Parameters: ${jsonEncode(parameters)}',
      );
    }
  }
}
