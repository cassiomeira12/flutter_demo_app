import 'package:core/core.dart';

class UserServiceImpl implements UserService {
  final UserDataSource _dataSource;

  UserServiceImpl({required UserDataSource userDataSource})
    : _dataSource = userDataSource;

  @override
  Future<UserModel> getUserData() async {
    try {
      final Map<String, dynamic> result = await _dataSource.getUserData();

      final UserModel user = UserModel.fromMap(result);

      return user;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }

  // @override
  // Future<UserModel> updateUserData(UserEntity user) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'name': user.name,
  //       'locale': user.locale,
  //     };

  //     await _dataSource.updateUserData(objectId: user.id, data: data);

  //     return await getUserData();
  //   } on HttpException catch (error) {
  //     throw ExceptionHelper.call(error);
  //   } catch (error, stacktrace) {
  //     Log.error(error.toString(), error: error, stackTrace: stacktrace);
  //     throw BaseException();
  //   }
  // }

  @override
  Future<void> deleteUser(String reason) async {
    try {
      await _dataSource.deleteUser(reason: reason);
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }

  @override
  Future<UserEntity> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.changePassword(
        username: username,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      final UserModel user = UserModel.fromMap(result);

      return user;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
