import 'package:core/src/appsflyer/appsflyer.dart';

class AppsFlyerServiceFaker implements AppsFlyerService {
  @override
  Future<void> init() async {}

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

  @override
  void deeplink() {}
}
