import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class PerformanceMetricUseCase {
  static Future<T> call<T>({
    required String name,
    String? description,
    TrackOperation? track,
    required Future<T> Function(TrackOperation track) builder,
  }) async {
    final startTimestamp = DateTime.timestamp();
    final TrackOperation internalTrack = track == null
        ? CrashlyticsServiceManager.instance.trackOperation(
            name: name,
            description: description,
            startTimestamp: startTimestamp,
          )
        : track.startChild(
            name: name,
            description: description,
            startTimestamp: startTimestamp,
          );
    try {
      return await builder.call(internalTrack);
    } catch (error, stackTrace) {
      internalTrack.setStatus(TrackOperationStatus.internalError);
      Log.error(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    } finally {
      final endTimestamp = DateTime.timestamp();
      internalTrack.finish(endTimestamp: endTimestamp);
      final seconds =
          endTimestamp.difference(startTimestamp).inMilliseconds / 1000;
      final String msg =
          'Tracking Operation \n'
          'name: $name \n'
          'duration: ${seconds.toStringAsFixed(3)} seconds';
      if (kProfileMode) {
        Log.warning(msg, throwsCrashlytics: false);
      }
    }
  }
}
