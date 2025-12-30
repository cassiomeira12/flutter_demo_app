import 'package:flutter_demo_app/data/models/check_hour_point_model.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckDayPointModel extends CheckDayPointEntity {
  CheckDayPointModel({
    required super.day,
    required super.today,
    required super.isWeekend,
    required super.isHoliday,
    required super.dateFormatted,
    required super.totalFormatted,
    required super.points,
  });

  factory CheckDayPointModel.fromMap(Map<String, dynamic> map) {
    return CheckDayPointModel(
      day: map['dia'] ?? 1,
      today: map['hoje'] ?? false,
      isWeekend: map['finalDeSemana'] ?? false,
      isHoliday: map['feriado'] ?? false,
      dateFormatted: map['dataFormatado'] ?? 'XX/XX/XXXX',
      totalFormatted: map['totalFormatado'] ?? 'XX:XX',
      points: List.from(map['apontamentos'] ?? [])
          .map((item) {
            return CheckHourPointModel.fromMap(item);
          })
          .where((item) => item.valor != null)
          .toList(),
    );
  }
}
