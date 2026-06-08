import 'package:admin/src/presentation/create_notification/create_notification.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CreateNotificationBindings extends Bindings {
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
      CreateNotificationUseCaseImpl(
        notificationService: AppBinding.find(),
      ),
    );

    AppBinding.put<TestPushNotificationUseCase>(
      TestPushNotificationUseCaseImpl(
        notificationService: AppBinding.find(),
      ),
    );

    AppBinding.put<CreateNotificationController>(
      CreateNotificationController(
        getAllUsersUseCase: AppBinding.find(),
        createNotificationUseCase: AppBinding.find(),
        testPushNotificationUseCase: AppBinding.find(),
      ),
    );
  }
}
