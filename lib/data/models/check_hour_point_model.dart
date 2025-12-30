import 'package:flutter_demo_app/domain/domain.dart';

class CheckHourPointModel extends CheckHourPointEntity {
  CheckHourPointModel({
    required super.index,
    required super.manual,
    required super.valor,
  });

  factory CheckHourPointModel.fromMap(Map<String, dynamic> map) {
    return CheckHourPointModel(
      index: map['index'] as int,
      manual: map['manual'] as bool,
      valor: map['valor'] as String?,
    );
  }
}
