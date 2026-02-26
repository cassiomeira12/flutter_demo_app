import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_controller.dart';

class CheckPointPage extends AppView<CheckPointController> {
  const CheckPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Check Point',
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          child: TextWidget('set_to_holiday'.tr),
          onTap: () async {
            final String? result = await _requestJustificationBottomSheet(
              context,
            );
            if (result != null) {
              controller.updateCheckDayPoint(
                holiday: true,
                info: result,
              );
            }
          },
        ),
        PopupMenuItem(
          child: TextWidget('set_to_allowance'.tr),
          onTap: () async {
            final String? result = await _requestJustificationBottomSheet(
              context,
            );
            if (result != null) {
              controller.updateCheckDayPoint(
                allowance: true,
                info: result,
              );
            }
          },
        ),
        PopupMenuItem(
          child: TextWidget('set_to_day_off'.tr),
          onTap: () async {
            final String? result = await _requestJustificationBottomSheet(
              context,
            );
            if (result != null) {
              controller.updateCheckDayPoint(
                dayOff: true,
                info: result,
              );
            }
          },
        ),
      ],
      body: Obx(() {
        return Skeletonizer(
          enabled: controller.loading.value,
          child: Container(
            padding: ResponsiveSizeHelper.cardPadding,
            color: Theme.of(context).highlightColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: ResponsiveSizeHelper.spacingDefaultHeight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'date'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.dateFormatted,
                      style: AppTextStyle.subtitle(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'holiday'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.checkPointDay?.isHoliday == true
                          ? 'yes'.tr
                          : 'not'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        color: controller.checkPointDay?.isHoliday == true
                            ? SemanticColors.positive700
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'allowance'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.checkPointDay?.isAllowance == true
                          ? 'yes'.tr
                          : 'not'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        color: controller.checkPointDay?.isAllowance == true
                            ? SemanticColors.positive700
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'day_off'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.checkPointDay?.isDayOff == true
                          ? 'yes'.tr
                          : 'not'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        color: controller.checkPointDay?.isDayOff == true
                            ? SemanticColors.positive700
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'weekend'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.checkPointDay?.isWeekend == true
                          ? 'yes'.tr
                          : 'not'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        color: controller.checkPointDay?.isWeekend == true
                            ? SemanticColors.positive700
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'total_hours'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      '${controller.checkPointDay?.totalFormatted ?? '00:00'}h',
                      style: AppTextStyle.subtitle(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      '${'has_inconsistency'.tr}:',
                      style: AppTextStyle.subtitle(context),
                    ),
                    TextWidget(
                      controller.checkPointDay?.hasInconsistency == true
                          ? 'yes'.tr
                          : 'not'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        color:
                            controller.checkPointDay?.hasInconsistency == true
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                    ),
                  ],
                ),
                if (controller.points.isNotEmpty) const Divider(),
                if (controller.checkPointDay?.info?.isNotEmpty ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                    children: [
                      if (controller.points.isEmpty) const Divider(),
                      TextWidget(
                        '${'justification'.tr}: ${controller.checkPointDay?.info}',
                        style: AppTextStyle.subtitle(context),
                      ),
                      const Divider(),
                    ],
                  ),
                Column(
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                  children: controller.points.map((hourPoint) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          '${'check_point'.tr}:',
                          style: AppTextStyle.subtitle(context),
                        ),
                        TextWidget(
                          hourPoint.valor ?? '--:--',
                          style: AppTextStyle.subtitle(context),
                        ),
                        SecondaryButton(
                          text: 'change'.tr,
                          size: ButtonSize.small,
                          onPressed: () async {
                            final TimeOfDay? timeSelected =
                                await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: hourPoint.hour,
                                    minute: hourPoint.minute,
                                  ),
                                  cancelText: 'cancel'.tr,
                                  confirmText: 'continue'.tr,
                                );

                            if (timeSelected != null) {
                              controller.updateCheckHourPoint(
                                hourPoint,
                                hour: timeSelected.hour,
                                minute: timeSelected.minute,
                              );
                            }
                          },
                        ),
                        PrimaryButton(
                          text: 'delete'.tr,
                          size: ButtonSize.small,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          onPressed: () async {
                            final bool? result = await DialogWidget.showChoice(
                              context,
                              title: 'delete_check_point'.tr,
                              message: 'delete_check_point_selected'.tr
                                  .replaceAll(
                                    '{checkHourPoint}',
                                    hourPoint.valor ?? '--:--',
                                  ),
                              okButton: 'continue'.tr,
                            );

                            if (result == true) {
                              try {
                                await controller.deleteCheckHourPoint(
                                  hourPoint,
                                );
                              } on BaseException catch (error) {
                                if (!context.mounted) return;
                                DialogWidget.showError(
                                  context,
                                  message: error.message.tr,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingButtonWidget(
        key: const Key('register_check_point_key'),
        icon: FlutterIcon(
          Icons.av_timer_sharp,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        ),
        onPressed: () async {
          final TimeOfDay? timeSelected = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            cancelText: 'cancel'.tr,
            confirmText: 'continue'.tr,
          );

          if (timeSelected != null) {
            try {
              await controller.registerCustomPoint(
                hour: timeSelected.hour,
                minute: timeSelected.minute,
              );
            } on BaseException catch (error) {
              if (!context.mounted) return;
              DialogWidget.showError(
                context,
                message: error.message.tr,
              );
            }
          }
        },
      ),
    );
  }

  Future<String?> _requestJustificationBottomSheet(
    BuildContext context,
  ) async {
    final formKey = GlobalKey<FormState>();
    final inputController = TextEditingController();
    return await BottomSheetWidget.show(
      context: context,
      isDismissible: false,
      child: Column(
        spacing: ResponsiveSizeHelper.spacingDefaultHeight,
        children: [
          Form(
            key: formKey,
            child: TextAreaFieldWidget(
              controller: inputController,
              label: 'justification'.tr,
              hintText: 'justification_hint'.tr,
              validator: (String? input) {
                if (input?.trim().isEmpty ?? true) {
                  return 'justification_hint'.tr;
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SecondaryButton(
                text: 'cancel'.tr,
                onPressed: () => Navigator.of(context).pop(),
              ),
              PrimaryButton(
                text: 'save'.tr,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final input = inputController.text.trim();
                    Navigator.of(context).pop(input);
                  }
                },
              ),
            ],
          ),
          const SpacerWidget(height: 2),
        ],
      ),
    );
  }
}
