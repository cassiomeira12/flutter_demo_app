import 'package:admin/src/data/data.dart';
import 'package:admin/src/domain/domain.dart';
import 'package:core/core.dart';

class GetAllUsersUseCaseImpl implements GetAllUsersUseCase {
  final UsersService _service;

  GetAllUsersUseCaseImpl({required UsersService userService})
    : _service = userService;

  @override
  Future<List<UserEntity>> call(int page) async {
    return _service.list();
  }
}
