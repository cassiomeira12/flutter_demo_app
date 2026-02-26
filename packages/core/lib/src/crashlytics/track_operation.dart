abstract class TrackOperation {
  TrackOperation startChild({
    required String operation,
    DateTime? startTimestamp,
  });

  void catchError({Object? error});

  void finish({DateTime? endTimestamp});
}
