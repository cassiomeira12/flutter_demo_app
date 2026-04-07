import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckDayPointEntity extends BaseEntity {
  final int day;
  final int month;
  final int year;
  final bool today;
  final bool isWeekend;
  final bool isAllowance;
  final bool isHoliday;
  final bool isDayOff;
  final String dateFormatted;
  final String totalFormatted;
  final List<CheckHourPointEntity> points;
  final bool hasInconsistency;
  final String? info;

  CheckDayPointEntity({
    required this.day,
    required this.month,
    required this.year,
    required this.today,
    required this.isWeekend,
    required this.isAllowance,
    required this.isHoliday,
    required this.isDayOff,
    required this.dateFormatted,
    required this.totalFormatted,
    required this.points,
    required this.hasInconsistency,
    required this.info,
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
  });

  bool get isDayToWork => !(isWeekend || isHoliday || isAllowance || isDayOff);

  @override
  CheckDayPointEntity copyWith({
    int? day,
    int? month,
    int? year,
    bool? today,
    bool? isWeekend,
    bool? isAllowance,
    bool? isHoliday,
    bool? isDayOff,
    String? dateFormatted,
    String? totalFormatted,
    List<CheckHourPointEntity>? points,
    bool? hasInconsistency,
    String? info,
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CheckDayPointEntity(
      day: day ?? this.day,
      month: day ?? this.month,
      year: day ?? this.year,
      today: today ?? this.today,
      isWeekend: isWeekend ?? this.isWeekend,
      isAllowance: isAllowance ?? this.isAllowance,
      isHoliday: isHoliday ?? this.isHoliday,
      isDayOff: isDayOff ?? this.isDayOff,
      dateFormatted: dateFormatted ?? this.dateFormatted,
      totalFormatted: totalFormatted ?? this.totalFormatted,
      points: points ?? this.points,
      hasInconsistency: hasInconsistency ?? this.hasInconsistency,
      info: info ?? this.info,
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'month': month,
      'year': year,
      'today': today,
      'weekend': isWeekend,
      'allowance': isAllowance,
      'holiday': isHoliday,
      'dayOff': isDayOff,
      'dateFormatted': dateFormatted,
      'totalFormatted': totalFormatted,
      'points': points,
      'hasInconsistency': hasInconsistency,
      'info': info,
      ...super.toMap(),
    };
  }
}
