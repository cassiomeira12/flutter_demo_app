import 'package:admin/src/data/data.dart';
import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

class UsersServiceImpl
    with ListServiceMixin<UserEntity>
    implements UsersService {
  final UsersDataSource _usersDataSource;

  UsersServiceImpl({required this._usersDataSource});

  @override
  Future<List<UserEntity>> list() {
    return mixinList(
      list: _usersDataSource.list,
      fromMap: UserModel.fromMap,
    );
  }
}
