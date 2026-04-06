abstract class TrackOperation {
  TrackOperation startChild({
    required String name,
    String? description,
    DateTime? startTimestamp,
  });

  void setData({required String key, required dynamic value});

  void setStatus(TrackOperationStatus? status);

  void finish({DateTime? endTimestamp});
}

enum TrackOperationStatus {
  ok,
  cancelled,
  internalError,
  unknownError,
  notFound,
  alreadyExists,
  permissionDenied,
  aborted,
  unavailable,
  dataLoss,
  unauthenticated,
}
