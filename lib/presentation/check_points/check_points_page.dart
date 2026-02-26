import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_controller.dart';
import 'package:flutter_demo_app/presentation/check_points/widgets/check_point_widget.dart';

class CheckPointsPage extends AppView<CheckPointsController> {
  const CheckPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      titleWidget: Obx(() {
        return TextWidget(
          'Work Points (${DateHelper.formatDateMonthYear(controller.selectedDate.value)})',
          style: AppTextStyle.subtitle(
            context,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        );
      }),
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          child: TextWidget('change_month'.tr),
          onTap: () {
            final today = DateTime.now();
            showMonthPicker(
              context,
              initialSelectedMonth: today.month,
              initialSelectedYear: today.year,
              firstYear: 2000,
              lastYear: today.year,
              selectButtonText: 'ok'.tr,
              cancelButtonText: 'cancel'.tr,
              highlightColor: NeutralColors.neutral800,
              onSelected: (int month, int year) {
                final selected = DateTime(year, month);
                controller.changeSelectedDate(selected);
              },
            );
          },
        ),
        PopupMenuItem(
          onTap: controller.getCurrentCheckPoints,
          child: TextWidget('update'.tr),
        ),
      ],
      body: ScrollStateWidget<CheckDayPointEntity>(
        list: controller.checkPoints,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.getCurrentCheckPoints,
        emptyMessage: 'empty_check_point_list'.tr,
        skeletonSizeItems: 10,
        fromMapBuilder: (map) {
          return CheckDayPointModel.fromMap(map).copyWith();
        },
        toMapBuilder: (item) => item.toMap(),
        builder: (context, index, checkPoint) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckPointWidget(
                checkDayPoint: checkPoint,
                onTap: () {
                  controller.openCheckPoint(checkPoint);
                },
              ),
              if (index == controller.checkPoints.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSizeHelper.height(50),
                  ),
                  child: TextWidget(
                    '${'total_hours'.tr}: ${controller.totalHours.value}h \n',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return FloatingButtonWidget(
          key: const Key('register_check_point_key'),
          icon: FlutterIcon(
            Icons.timer_sharp,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          onPressed: () async {
            final bool? result = await DialogWidget.showChoice(
              context,
              title: 'make_check_point'.tr,
              message: 'make_check_point_now'.tr,
              okButton: 'continue'.tr,
            );
            if (result == true) {
              try {
                await controller.registerPoint();
              } on BaseException catch (error) {
                if (!context.mounted) return;
                DialogWidget.showError(
                  context,
                  message: error.message.tr.replaceAll(
                    '{hourPoint}',
                    DateHelper.formatHourMinute(DateTime.now()),
                  ),
                );
              }
            }
          },
        );
      }),
    );
  }
}
