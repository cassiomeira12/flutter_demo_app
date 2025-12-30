import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class NotificationsController extends LifecycleController {
  final ListUserNotificationsUseCase _listUserNotificationsUseCase;
  final ReadNotificationUseCase _readNotificationUseCase;

  NotificationsController({
    required ListUserNotificationsUseCase listUserNotifications,
    required ReadNotificationUseCase readNotificationUseCase,
  }) : _listUserNotificationsUseCase = listUserNotifications,
       _readNotificationUseCase = readNotificationUseCase;

  RxList<NotificationEntity> notifications = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  @override
  void onReady() {
    super.onReady();
    getAllNotifications();
  }

  Future<void> getAllNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      notifications.value = await _listUserNotificationsUseCase.call(0);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> readNotification(NotificationEntity notification) async {
    if (notification.viewed) return;
    clickTagging(component: 'notification_item_key');
    await _readNotificationUseCase.call(notification);
    await getAllNotifications();
    await refreshUnCountNotifications();
  }

  void refreshNotifications() {
    clickTagging(component: 'onboarding_update_popup_menu_item_key');
    getAllNotifications();
    refreshUnCountNotifications();
  }

  void openSettings() {
    clickTagging(component: 'onboarding_settings_popup_menu_item_key');
    AppNavigator.toNamed(AppRouter.notificationsSettings);
  }
}
