import 'package:admin/src/data/data.dart';
import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/infra/infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'users.dart';

class UsersBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UsersDataSource>(
      UsersDataSourceImpl(http: AppBinding.find()),
    );

    AppBinding.put<UsersService>(
      UsersServiceImpl(usersDataSource: AppBinding.find()),
      permanent: true,
    );

    AppBinding.put<GetAllUsersUseCase>(
      GetAllUsersUseCaseImpl(userService: AppBinding.find()),
    );

    AppBinding.put<UsersController>(
      UsersController(
        getAllUsersUseCase: AppBinding.find(),
        usersStore: AppBinding.find(),
      ),
    );
  }
}
