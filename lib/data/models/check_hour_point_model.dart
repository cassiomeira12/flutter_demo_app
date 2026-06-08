import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckHourPointModel extends CheckHourPointEntity {
  CheckHourPointModel({
    required super.objectId,
    required super.manual,
    required super.value,
  });

  factory CheckHourPointModel.fromMap(Map<String, dynamic> map) {
    try {
      return CheckHourPointModel(
        objectId: map['objectId'] as String,
        manual: map['manual'] as bool,
        value: map['time'] as String?,
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
