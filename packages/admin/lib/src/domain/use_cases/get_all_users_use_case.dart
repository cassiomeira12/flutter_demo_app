import 'package:core/core.dart';

abstract class GetAllUsersUseCase {
  Future<List<UserEntity>> call(int page);
}
