abstract class TrackOperation {
  TrackOperation startChild({String? operation});

  void catchError({Object? error});

  void finish();
}
