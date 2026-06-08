import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointWidget extends StatelessWidget {
  final CheckDayPointEntity checkDayPoint;

  const CheckPointWidget({super.key, required this.checkDayPoint});

  @override
  Widget build(BuildContext context) {
    final todayTextStyle = AppTextStyle.message(
      context,
      color: checkDayPoint.isDayToWork
          ? checkDayPoint.today
                ? Theme.of(
                    context,
                  ).textButtonTheme.style?.textStyle?.resolve({
                    WidgetState.selected,
                  })?.color
                : null
          : Theme.of(context).textTheme.bodyMedium?.color,
    );

    return Container(
      color: checkDayPoint.isDayToWork
          ? checkDayPoint.today
                ? Theme.of(context).cardColor
                : Theme.of(context).highlightColor
          : null,
      height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSizeHelper.width(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextWidget(
            checkDayPoint.dateFormatted,
            style: todayTextStyle,
          ),
          if (checkDayPoint.isDayToWork || checkDayPoint.points.isNotEmpty)
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: ResponsiveSizeHelper.width(50),
                    alignment: Alignment.center,
                    child: TextWidget(
                      index >= checkDayPoint.points.length
                          ? '--:--'
                          : checkDayPoint.points[index].value ?? '--:--',
                      style: todayTextStyle,
                    ),
                  );
                }),
              ),
            ),
          if (checkDayPoint.isWeekend && checkDayPoint.points.isEmpty)
            Expanded(flex: 4, child: Center(child: TextWidget('weekend'.tr))),
          if (checkDayPoint.isHoliday && checkDayPoint.points.isEmpty)
            Expanded(flex: 4, child: Center(child: TextWidget('holiday'.tr))),
          if (!(checkDayPoint.isWeekend || checkDayPoint.isHoliday) ||
              checkDayPoint.points.isNotEmpty)
            TextWidget(
              checkDayPoint.totalFormatted,
              style: todayTextStyle,
            ),
        ],
      ),
    );
  }
}
