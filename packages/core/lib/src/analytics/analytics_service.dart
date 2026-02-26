abstract class AnalyticsService {
  Future<void> init();

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  });

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  });
}
