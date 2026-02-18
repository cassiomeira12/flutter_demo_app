import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:push_notifications/src/presentation/push_notifications/push_notifications.dart';

class PushNotificationsBindings extends Bindings {
  @override
  void dependencies() {
    // AppBinding.lazyPut<IUsersDataSource>(
    //   () => UsersDataSource(
    //     http: AppBinding.find(),
    //   ),
    // );
    // AppBinding.lazyPut<IUsersRepository>(
    //   () => UsersRepository(
    //     dataSource: AppBinding.find(),
    //   ),
    // );
    // AppBinding.lazyPut<IGetAllUsersUseCase>(
    //   () => GetAllUsersUseCase(
    //     repository: AppBinding.find(),
    //   ),
    // );

    // AppBinding.lazyPut<ICreateNotificationUseCase>(
    //   () => CreateNotificationUseCase(
    //     repository: AppBinding.find(),
    //   ),
    // );

    // AppBinding.lazyPut<ITestPushNotificationUseCase>(
    //   () => TestPushNotificationUseCase(
    //     repository: AppBinding.find(),
    //   ),
    // );

    AppBinding.put<PushNotificationsController>(
      PushNotificationsController(
        // getAllUsersUseCase: AppBinding.find(),
        createNotificationUseCase: AppBinding.find(),
        testPushNotificationUseCase: AppBinding.find(),
      ),
    );
  }
}
