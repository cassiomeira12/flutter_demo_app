import 'package:core/core.dart';

class CollectionTrackOperation extends TrackOperation {
  final List<TrackOperation> _services;

  CollectionTrackOperation(
    List<TrackOperation> services,
  ) : _services = services;

  List<T> _runServices<T>(
    T Function(TrackOperation service) builder, {
    required String functionName,
  }) {
    final List<T> operations = List<T>.empty(growable: true);
    for (final service in _services) {
      try {
        operations.add(builder.call(service));
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }
    return operations;
  }

  @override
  TrackOperation startChild({
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    return CollectionTrackOperation(
      _runServices(
        (TrackOperation service) => service.startChild(
          name: name,
          description: description,
          startTimestamp: startTimestamp,
        ),
        functionName: 'startChild',
      ),
    );
  }

  @override
  void setStatus(TrackOperationStatus? status) {
    _runServices(
      (TrackOperation service) => service.setStatus(status),
      functionName: 'setStatus',
    );
  }

  @override
  void setData({required String key, required dynamic value}) {
    _runServices(
      (TrackOperation service) => service.setData(key: key, value: value),
      functionName: 'setData',
    );
  }

  @override
  void finish({DateTime? endTimestamp}) {
    _runServices(
      (TrackOperation service) => service.finish(endTimestamp: endTimestamp),
      functionName: 'setData',
    );
  }
}
