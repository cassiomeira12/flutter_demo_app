import 'package:core/core.dart';

abstract class UsersService {
  Future<List<UserEntity>> list();
}
