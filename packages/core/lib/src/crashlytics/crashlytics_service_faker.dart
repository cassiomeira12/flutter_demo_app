import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CrashlyticsServiceFaker implements CrashlyticsService {
  @override
  Future<void> init() async {}

  @override
  Future<void> updateInitSettings() async {}

  @override
  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.debug,
  }) {}

  @override
  void logHttp(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.http,
  }) {}

  @override
  void logUserInteraction(
    String event, {
    Map<String, dynamic>? parameters,
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.user,
  }) {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {}

  @override
  void setIpAddress(IpAddressLocationEntity ipAddress) {}

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
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    startTimestamp ??= DateTime.timestamp();
    final String msg =
        '[Start] Tracking Operation \n'
        'name: $name \n'
        'description: $description \n'
        'startAt: $startTimestamp';
    if (Log.showPerformanceTrackLogs) {
      Log.info(msg);
    }
    return FakeTrackOperation(
      name: name,
      description: description,
      startTimestamp: startTimestamp,
    );
  }

  @override
  void simulateCrash() {}
}

class FakeTrackOperation implements TrackOperation {
  final String _parentName;
  final String? _description;
  final DateTime _startTimestamp;
  final bool isChild;

  bool finished = false;

  FakeTrackOperation({
    required String name,
    required this._description,
    required this._startTimestamp,
    this.isChild = false,
  }) : _parentName = name;

  @override
  TrackOperation startChild({
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    startTimestamp ??= DateTime.timestamp();
    final String msg =
        '[Start] Child Tracking Operation \n'
        'parent: $_parentName \n'
        'name: $name \n'
        'description: $description \n'
        'startAt: $startTimestamp';
    if (Log.showPerformanceTrackLogs) {
      Log.info(msg);
    }
    return FakeTrackOperation(
      name: name,
      description: null,
      startTimestamp: startTimestamp,
      isChild: true,
    );
  }

  @override
  void setData({required String key, required dynamic value}) {}

  @override
  void setStatus(TrackOperationStatus? status) {}

  @override
  void finish({DateTime? endTimestamp}) {
    if (finished) return;
    finished = true;
    final endTime = endTimestamp ?? DateTime.timestamp();
    final milliseconds = endTime.difference(_startTimestamp).inMilliseconds;
    final timeFormatted = milliseconds / 1000;
    if (milliseconds >= 200) {
      final String msg =
          '[Finish] ${isChild ? 'Child ' : ''}Tracking Operation \n'
          '${isChild ? 'parent:' : 'name:'} $_parentName \n'
          'description: $_description \n'
          'endAt: $endTime \n'
          'duration: ${timeFormatted.toStringAsFixed(3)} seconds';
      if (Log.showPerformanceTrackLogs) {
        Log.tracking(msg);
      }
    } else {
      final String msg =
          '[Finish] ${isChild ? 'Child ' : ''}Tracking Operation \n'
          '${isChild ? 'parent:' : 'name:'} $_parentName \n'
          'description: $_description \n'
          'endAt: $endTime \n'
          'duration: ${timeFormatted.toStringAsFixed(3)} seconds';
      if (Log.showPerformanceTrackLogs) {
        Log.success(msg, throwsCrashlytics: false);
      }
    }
  }
}
