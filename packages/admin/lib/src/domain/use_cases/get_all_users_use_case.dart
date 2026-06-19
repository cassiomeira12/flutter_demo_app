import 'package:admin/src/data/data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetAllUsersUseCase
    extends BaseUseCaseAsyncParam<List<UserEntity>, int> {}

class GetAllUsersUseCaseImpl implements GetAllUsersUseCase {
  final UsersService _userService;

  GetAllUsersUseCaseImpl({required this._userService});

  @override
  Future<List<UserEntity>> call(int page) {
    return _userService.list();
  }
}
