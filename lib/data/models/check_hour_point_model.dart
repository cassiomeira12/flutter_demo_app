import 'package:flutter_demo_app/domain/domain.dart';

class CheckHourPointModel extends CheckHourPointEntity {
  CheckHourPointModel({
    required super.manual,
    required super.valor,
  });

  factory CheckHourPointModel.fromMap(Map<String, dynamic> map) {
    return CheckHourPointModel(
      manual: map['manual'] as bool,
      valor: map['time'] as String?,
    );
  }
}
