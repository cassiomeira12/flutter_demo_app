import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class UserServiceImpl implements UserService {
  final UserDataSource _userDataSource;

  UserServiceImpl({required this._userDataSource});

  @override
  Future<UserModel> getUserData() async {
    try {
      final Map<String, dynamic> result = await _userDataSource.getUserData();
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

  @override
  Future<void> deleteUser(String reason) async {
    try {
      await _userDataSource.deleteUser(reason: reason);
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

  @override
  Future<UserEntity> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) async {
    try {
      try {
        final Map<String, dynamic> updateData = {
          'name': data['name'],
          'locale': data['locale'],
        };
        await _userDataSource.updateUserData(
          objectId: objectId,
          data: updateData,
        );
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
      return await getUserData();
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

  @override
  Future<UserModel> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await _userDataSource.changePassword(
        username: username,
        currentPassword: currentPassword,
        newPassword: newPassword,
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
