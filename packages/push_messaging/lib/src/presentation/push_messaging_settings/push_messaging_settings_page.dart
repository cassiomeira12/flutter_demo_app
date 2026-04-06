import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:push_messaging/src/presentation/push_messaging_settings/push_messaging_settings.dart';

class PushMessagingSettingsPage
    extends AppView<PushMessagingSettingsController> {
  const PushMessagingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'notifications_settings'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(0)),
              child: Column(
                spacing: ResponsiveSizeHelper.spacingDefaultHeight * 2,
                children: [
                  ColoredBox(
                    color: Theme.of(context).highlightColor,
                    child: Padding(
                      padding: ResponsiveSizeHelper.cardPadding,
                      child: Obx(() {
                        return SwitchTitleWidget(
                          key: const Key('notifications_switch_key'),
                          text: 'allow_push_notifications'.tr,
                          initialValue: controller.notificationsEnabled.value,
                          onChanged: (enabled) async {
                            try {
                              final bool? enabledResult = await controller
                                  .toggleNotification(enabled);
                              if (enabledResult == null) {
                                if (!context.mounted) return;

                                DialogWidget.show(
                                  context,
                                  title: 'no_push_permissions'.tr,
                                  message:
                                      'you_need_enabled_push_permissions'.tr,
                                );
                                return;
                              }
                              if (!context.mounted) return;

                              DialogWidget.show(
                                context,
                                title:
                                    '${'notification'.tr} ${enabledResult ? 'push_enabled'.tr : 'push_disabled'.tr}',
                                message: enabledResult
                                    ? 'you_will_receive_notifications'.tr
                                    : 'push_notifications_disabled'.tr,
                              );
                            } catch (error) {
                              if (!context.mounted) return;
                              DialogWidget.showError(
                                context,
                                message: error.toString().tr,
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ),
                  ColoredBox(
                    color: Theme.of(context).highlightColor,
                    child: Padding(
                      padding: ResponsiveSizeHelper.cardPadding,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: ResponsiveSizeHelper.maxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              'push_notifications'.tr,
                              style: AppTextStyle.subtitle(context),
                            ),
                            const SpacerWidget(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: TextWidget(
                                    'send_push_notification_test'.tr,
                                    style: AppTextStyle.footnote(context),
                                  ),
                                ),
                                const SpacerWidget(),
                                Obx(() {
                                  return FutureButton(
                                    key: const Key(
                                      'test_push_notification_key',
                                    ),
                                    text: 'send_push_test'.tr,
                                    size: ButtonSize.medium,
                                    onPressed:
                                        controller.notificationsEnabled.value
                                        ? () async {
                                            final result = await controller
                                                .testPush();

                                            if (!context.mounted) return;

                                            if (result is Error) {
                                              DialogWidget.showError(
                                                context,
                                                message:
                                                    result.error.message.tr,
                                              );
                                            } else {
                                              DialogWidget.show(
                                                context,
                                                title:
                                                    'test_push_send_success_title'
                                                        .tr,
                                                message:
                                                    'test_push_send_success_message'
                                                        .tr,
                                              );
                                            }
                                          }
                                        : null,
                                  );
                                }),
                              ],
                            ),
                            const SpacerWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!kReleaseMode)
                    InkWell(
                      onTap: () async {
                        controller.copyToken();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: const TextWidget('Push token copiado!'),
                          ),
                        );
                      },
                      child: ColoredBox(
                        color: StaticColors.debug,
                        child: Padding(
                          padding: ResponsiveSizeHelper.cardPadding,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: ResponsiveSizeHelper.maxWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  'Push Token',
                                  style: AppTextStyle.subtitle(
                                    context,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SpacerWidget(),
                                Obx(() {
                                  return TextWidget(
                                    controller.pushToken.value,
                                    style: AppTextStyle.footnote(
                                      context,
                                      color: Colors.black87,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
