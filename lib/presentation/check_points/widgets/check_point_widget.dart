import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointWidget extends StatelessWidget {
  final CheckDayPointEntity checkDayPoint;
  final VoidCallback onTap;

  const CheckPointWidget({
    super.key,
    required this.checkDayPoint,
    required this.onTap,
  });

  String get textNotDayToWork {
    if (checkDayPoint.isAllowance) {
      return 'allowance'.tr;
    }
    if (checkDayPoint.isHoliday) {
      return 'holiday'.tr;
    }
    if (checkDayPoint.isDayOff) {
      return 'day_off'.tr;
    }
    if (checkDayPoint.isWeekend) {
      return 'weekend'.tr;
    }
    return '';
  }

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

    final totalTextStyle = AppTextStyle.message(
      context,
      color: checkDayPoint.hasInconsistency && !checkDayPoint.today
          ? Theme.of(context).colorScheme.error
          : checkDayPoint.isDayToWork
          ? checkDayPoint.today
                ? Theme.of(
                    context,
                  ).textButtonTheme.style?.textStyle?.resolve({
                    WidgetState.selected,
                  })?.color
                : null
          : Theme.of(context).textTheme.bodyMedium?.color,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        color: checkDayPoint.isDayToWork
            ? checkDayPoint.today
                  ? Theme.of(context).cardColor
                  : Theme.of(context).highlightColor
            : null,
        height: kToolbarHeight,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeHelper.width(20),
        ),
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
            if (!checkDayPoint.isDayToWork && checkDayPoint.points.isEmpty)
              Expanded(
                flex: 4,
                child: Center(child: TextWidget(textNotDayToWork)),
              ),
            if (checkDayPoint.isDayToWork || checkDayPoint.points.isNotEmpty)
              TextWidget(
                checkDayPoint.totalFormatted,
                style: totalTextStyle,
              ),
          ],
        ),
      ),
    );
  }
}
