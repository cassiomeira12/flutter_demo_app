import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CrashlyticsServiceFaker implements CrashlyticsService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
  }) {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {}

  @override
  Future<void> captureException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) async {}

  @override
  Future<void> captureFatalException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) async {}

  @override
  TrackOperation trackOperation({
    String? name,
    String? operation,
    DateTime? startTimestamp,
  }) {
    return FakeTrackOperation(
      name: name,
      operation: operation,
      startTimestamp: startTimestamp ?? DateTime.timestamp(),
    );
  }

  @override
  void simulateCrash() {}
}

class FakeTrackOperation implements TrackOperation {
  final String? _name;
  final String? _operation;
  final DateTime _startTimestamp;

  FakeTrackOperation({
    required String? name,
    required String? operation,
    required DateTime startTimestamp,
  }) : _name = name,
       _operation = operation,
       _startTimestamp = startTimestamp;

  @override
  TrackOperation startChild({
    String? name,
    String? operation,
    DateTime? startTimestamp,
  }) {
    return FakeTrackOperation(
      name: name ?? _operation,
      operation: operation,
      startTimestamp: startTimestamp ?? DateTime.timestamp(),
    );
  }

  @override
  void catchError({Object? error, StackTrace? stackTrace}) {}

  @override
  void finish({DateTime? endTimestamp}) {
    final endTime = endTimestamp ?? DateTime.timestamp();
    final String msg =
        'Tracking Operation \n'
        'name: $_name \n'
        'operation: $_operation \n'
        'duration: ${endTime.difference(_startTimestamp).inMilliseconds / 1000} seconds';
    Log.warning(msg, throwsCrashlytics: false);
  }
}
