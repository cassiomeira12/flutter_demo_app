import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:notifications/src/presentation/notifications/notifications.dart';
import 'package:notifications/src/presentation/notifications/widgets/notification_widget.dart';

class NotificationsPage extends AppView<NotificationsController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'notifications'.tr,
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          key: const Key('notifications_update_popup_menu_item_key'),
          value: 'update'.tr,
          onTap: controller.refreshNotifications,
          child: TextWidget('update'.tr),
        ),
        PopupMenuItem(
          key: const Key('notifications_settings_popup_menu_item_key'),
          value: 'settings'.tr,
          onTap: controller.openSettings,
          child: TextWidget('settings'.tr),
        ),
      ],
      body: ScrollStateWidget<NotificationEntity>(
        list: controller.notifications,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.getAllNotifications,
        emptyMessage: 'empty_notifications_list'.tr,
        fromMapBuilder: (map) {
          return NotificationModel.fromMap(map).copyWith();
        },
        toMapBuilder: (item) => item.toMap(),
        builder: (context, index, item) {
          return NotificationWidget(
            key: Key('notification_item_index_${index}_key'),
            notification: item,
            onTap: () {
              controller.readNotification(item);
            },
          );
        },
      ),
    );
  }
}
