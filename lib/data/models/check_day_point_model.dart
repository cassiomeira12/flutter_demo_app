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
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CheckDayPointModel.fromMap(Map<String, dynamic> map) {
    try {
      return CheckDayPointModel(
        day: map['day'] ?? 1,
        month: map['month'] ?? 1,
        year: map['year'] ?? 1,
        today: map['today'] ?? false,
        isWeekend: map['weekend'] ?? false,
        isAllowance: map['allowance'] ?? false,
        isHoliday: map['holiday'] ?? false,
        isDayOff: map['dayOff'] ?? false,
        dateFormatted: map['dateFormatted'] ?? 'XX/XX/XXXX',
        totalFormatted: map['totalFormatted'] ?? 'XX:XX',
        points: List.from(map['workPoints'] ?? [])
            .map((item) {
              return CheckHourPointModel.fromMap(item);
            })
            .where((item) => item.value != null)
            .toList(),
        hasInconsistency: map['hasInconsistency'] ?? false,
        info: map['info'],
        objectId: map['objectId'] ?? '',
        createdAt: map['createdAt'] == null
            ? null
            : DateTime.tryParse(map['createdAt']),
        updatedAt: map['updatedAt'] == null
            ? null
            : DateTime.tryParse(map['updatedAt']),
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
