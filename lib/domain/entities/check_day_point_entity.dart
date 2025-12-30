import 'package:flutter_demo_app/domain/domain.dart';

class CheckDayPointEntity {
  final int day;
  final bool today;
  final bool isWeekend;
  final bool isHoliday;
  final String dateFormatted;
  final String totalFormatted;
  final List<CheckHourPointEntity> points;

  CheckDayPointEntity({
    required this.day,
    required this.today,
    required this.isWeekend,
    required this.isHoliday,
    required this.dateFormatted,
    required this.totalFormatted,
    required this.points,
  });

  bool get isDayToWork => !(isWeekend || isHoliday);

  CheckDayPointEntity copyWith({
    int? day,
    bool? today,
    bool? isWeekend,
    bool? isHoliday,
    String? dateFormatted,
    String? totalFormatted,
    List<CheckHourPointEntity>? points,
  }) {
    return CheckDayPointEntity(
      day: day ?? this.day,
      today: today ?? this.today,
      isWeekend: isWeekend ?? this.isWeekend,
      isHoliday: isHoliday ?? this.isHoliday,
      dateFormatted: dateFormatted ?? this.dateFormatted,
      totalFormatted: totalFormatted ?? this.totalFormatted,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'today': today,
      'isWeekend': isWeekend,
      'isHoliday': isHoliday,
      'dateFormatted': dateFormatted,
      'totalFormatted': totalFormatted,
      'points': points,
    };
  }
}
