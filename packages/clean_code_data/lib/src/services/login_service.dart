import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class LoginServiceImpl implements LoginService {
  final LoginDataSource _dataSource;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;

  LoginServiceImpl({
    required LoginDataSource loginDataSource,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
  }) : _dataSource = loginDataSource,
       _encryptServerUseCase = encryptServerPublicKeyUseCase;

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final encryptedPassword = await _encryptServerUseCase.call(password);

      final Map<String, dynamic> result = await _dataSource.login(
        username: username,
        password: encryptedPassword,
      );

      return UserModel.fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
