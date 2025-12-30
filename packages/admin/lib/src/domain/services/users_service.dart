import 'package:admin/src/data/data.dart';
import 'package:core/core.dart';

class UsersServiceImpl
    with ListServiceMixin<UserEntity>
    implements UsersService {
  final UsersDataSource _dataSource;

  UsersServiceImpl({required UsersDataSource usersDataSource})
    : _dataSource = usersDataSource;

  @override
  Future<List<UserEntity>> list() async {
    return await mixinList(list: _dataSource.list, fromMap: UserModel.fromMap);
  }
}
