import 'package:core/core.dart';

class UninitializedTrackOperation extends TrackOperation {
  final String name;
  final String? description;
  final DateTime startTimestamp;
  final Function(UninitializedTrackOperation parent)? onFinishedOperation;

  final bool isChild;
  List<UninitializedTrackOperation> children = List.empty(growable: true);

  bool finished = false;
  TrackOperationStatus? status;
  Map<String, dynamic> data = {};
  DateTime? endTimestamp;

  UninitializedTrackOperation({
    required this.name,
    this.description,
    required this.startTimestamp,
    this.isChild = false,
    this.onFinishedOperation,
  });

  @override
  TrackOperation startChild({
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    final child = UninitializedTrackOperation(
      name: name,
      description: description,
      startTimestamp: startTimestamp ?? DateTime.timestamp(),
      isChild: true,
    );
    children.add(child);
    return child;
  }

  @override
  void setStatus(TrackOperationStatus? status) {
    this.status = status;
  }

  @override
  void setData({required String key, required dynamic value}) {
    data[key] = value;
  }

  @override
  void finish({DateTime? endTimestamp}) {
    if (finished) return;
    finished = true;
    this.endTimestamp = endTimestamp ?? DateTime.timestamp();
    onFinishedOperation?.call(this);
  }
}
