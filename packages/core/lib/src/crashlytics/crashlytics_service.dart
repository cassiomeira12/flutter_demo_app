abstract class CrashlyticsService {
  Future<void> init();

  Future<void> setUserId(String userId);

  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  });

  void log(String message);

  Future<void> captureException({
    required Object error,
    StackTrace? stackTrace,
  });

  Future<void> captureFatalException({
    required Object error,
    StackTrace? stackTrace,
  });
}
