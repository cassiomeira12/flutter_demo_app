import 'package:core/core.dart';

mixin FallbackTrackOperationsMixin {
  final List<UninitializedTrackOperation> _uninitializedOperations = List.empty(
    growable: true,
  );

  void sendAllUninitializedTrackOperation() {
    for (final track in _uninitializedOperations) {
      callbackFinishedTrackOperation(track);
    }
    _uninitializedOperations.clear();
  }

  void saveUninitializedTrackOperation(UninitializedTrackOperation track) {
    _uninitializedOperations.add(track);
  }

  void callbackFinishedTrackOperation(
    UninitializedTrackOperation parent,
  ) {
    try {
      _finishTrackOperation(parent);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  void _finishTrackOperation(UninitializedTrackOperation parent) {
    final parentTrack = CrashlyticsServiceManager.instance.trackOperation(
      name: parent.name,
      description: parent.description,
      startTimestamp: parent.startTimestamp,
    );

    _setTrackOperation(parent, parentTrack);
    _finishChildrenRecursively(parent, parentTrack);

    parentTrack.finish(endTimestamp: parent.endTimestamp);
  }

  void _finishChildrenRecursively(
    UninitializedTrackOperation parent,
    TrackOperation parentTrack,
  ) {
    for (final child in parent.children) {
      final childTrack = parentTrack.startChild(
        name: child.name,
        description: child.description,
        startTimestamp: child.startTimestamp,
      );

      _setTrackOperation(child, childTrack);
      _finishChildrenRecursively(child, childTrack);

      childTrack.finish(endTimestamp: child.endTimestamp);
    }
  }

  void _setTrackOperation(
    UninitializedTrackOperation parent,
    TrackOperation parentTrack,
  ) {
    parentTrack.setStatus(parent.status);
    for (final entry in parent.data.entries) {
      parentTrack.setData(key: entry.key, value: entry.value);
    }
  }
}
