import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';

class SignupServiceImpl
    with CreateServiceMixin<UserEntity>
    implements SignupService {
  final SignupDataSource _dataSource;

  SignupServiceImpl({required SignupDataSource signUpDataSource})
    : _dataSource = signUpDataSource;

  @override
  Future<UserEntity> create(Map<String, dynamic> data) {
    return mixinCreate(
      data: data,
      create: _dataSource.create,
      fromMap: UserModel.fromMap,
    );
  }
}
