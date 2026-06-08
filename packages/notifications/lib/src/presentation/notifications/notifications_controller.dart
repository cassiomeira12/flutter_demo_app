import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:notifications/src/domain/domain.dart';

class NotificationsController extends LifecycleController {
  final ListUserNotificationsUseCase _listUserNotifications;
  final ReadNotificationUseCase _readNotificationUseCase;

  NotificationsController({
    required this._listUserNotifications,
    required this._readNotificationUseCase,
  });

  RxList<NotificationEntity> notifications = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  @override
  void onReady() {
    super.onReady();
    getAllNotifications();
  }

  Future<void> getAllNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      notifications.value = await _listUserNotifications.call(0);
    } on BaseException catch (error) {
      errorMessage.value = error.message.tr;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
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
