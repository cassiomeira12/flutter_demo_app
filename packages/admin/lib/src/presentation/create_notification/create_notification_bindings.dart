import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'create_notification.dart';

class PushNotificationsBindings extends Bindings {
  @override
  void dependencies() {
    // AppBinding.lazyPut<UsersDataSource>(
    //   () => UsersDataSourceImpl(http: AppBinding.find()),
    // );
    // AppBinding.put<UsersService>(
    //   UsersServiceImpl(usersDataSource: AppBinding.find()),
    // );
    // AppBinding.put<GetAllUsersUseCase>(
    //   GetAllUsersUseCaseImpl(userService: AppBinding.find()),
    // );

    AppBinding.put<CreateNotificationUseCase>(
      CreateNotificationUseCaseImpl(notificationService: AppBinding.find()),
    );

    AppBinding.put<TestPushNotificationUseCase>(
      TestPushNotificationUseCaseImpl(notificationService: AppBinding.find()),
    );

    AppBinding.put<PushNotificationsController>(
      PushNotificationsController(
        getAllUsersUseCase: AppBinding.find(),
        createNotificationUseCase: AppBinding.find(),
        testPushNotificationUseCase: AppBinding.find(),
      ),
    );
  }
}
