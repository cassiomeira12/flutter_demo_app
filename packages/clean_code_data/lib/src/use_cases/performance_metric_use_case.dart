import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class PerformanceMetricUseCase {
  static Future<T> call<T>({
    required String name,
    String? operation,
    TrackOperation? track,
    required Future<T> Function() builder,
  }) async {
    late TrackOperation internalTrack;
    if (track != null) {
      internalTrack = track.startChild(operation: name);
    } else {
      internalTrack = CrashlyticsServiceManager.instance.trackOperation(
        name: name,
        operation: operation,
      );
    }
    final startTimestamp = DateTime.timestamp();
    try {
      return await builder.call();
    } catch (error) {
      internalTrack.catchError(error: error);
      rethrow;
    } finally {
      internalTrack.finish();
      final endTimestamp = DateTime.timestamp();
      final String msg =
          'Tracking Operation \n'
          'name: $name \n'
          'operation: $operation \n'
          'duration: ${endTimestamp.difference(startTimestamp).inMilliseconds / 1000} seconds';
      if (kProfileMode) {
        Log.warning(msg, throwsCrashlytics: false);
      }
    }
  }
}
