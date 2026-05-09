import 'package:core/core.dart';

class UserServiceImpl implements UserService {
  final UserDataSource _dataSource;

  UserServiceImpl({required UserDataSource userDataSource})
    : _dataSource = userDataSource;

  @override
  Future<UserModel> getUserData() async {
    try {
      final Map<String, dynamic> result = await _dataSource.getUserData();
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
      await _dataSource.deleteUser(reason: reason);
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
        await _dataSource.updateUserData(objectId: objectId, data: updateData);
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
      final result = await _dataSource.changePassword(
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
