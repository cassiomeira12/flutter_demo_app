import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
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
    try {
      return CheckDayPointModel(
        day: map['day'] ?? 1,
        today: map['today'] ?? false,
        isWeekend: map['weekend'] ?? false,
        isHoliday: map['holiday'] ?? false,
        dateFormatted: map['dateFormatted'] ?? 'XX/XX/XXXX',
        totalFormatted: map['totalFormatted'] ?? 'XX:XX',
        points: List.from(map['workPoints'] ?? [])
            .map((item) {
              return CheckHourPointModel.fromMap(item);
            })
            .where((item) => item.valor != null)
            .toList(),
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
