import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckDayPointModel extends CheckDayPointEntity {
  CheckDayPointModel({
    required super.day,
    required super.month,
    required super.year,
    required super.today,
    required super.isWeekend,
    required super.isAllowance,
    required super.isHoliday,
    required super.isDayOff,
    required super.dateFormatted,
    required super.totalFormatted,
    required super.points,
    required super.hasInconsistency,
    required super.info,
  });

  factory CheckDayPointModel.fromMap(Map<String, dynamic> map) {
    try {
      return CheckDayPointModel(
        day: map['dia'] ?? 1,
        month: map['mes'] ?? 1,
        year: map['ano'] ?? 1,
        today: map['hoje'] ?? false,
        isWeekend: map['finalDeSemana'] ?? false,
        isAllowance: map['abonado'] ?? false,
        isHoliday: map['feriado'] ?? false,
        isDayOff: false,
        dateFormatted: map['dataFormatado'] ?? 'XX/XX/XXXX',
        totalFormatted: map['totalFormatado'] ?? 'XX:XX',
        points: List.from(map['apontamentos'] ?? [])
            .map((item) {
              return CheckHourPointModel.fromMap(item);
            })
            .where((item) => item.valor != null)
            .toList(),
        hasInconsistency: false,
        info: map['comentario'],
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
