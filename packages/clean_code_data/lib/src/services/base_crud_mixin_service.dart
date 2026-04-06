import 'package:core/core.dart';

class BaseCrudServiceMixin<T>
    with
        CreateServiceMixin<T>,
        DeleteServiceMixin<T>,
        ListServiceMixin<T>,
        UpdateServiceMixin<T> {}

mixin CreateServiceMixin<T> {
  Future<T> mixinCreate({
    required Map<String, dynamic> data,
    required Future<Map<String, dynamic>> Function(Map<String, dynamic> data)
    create,
    required T Function(Map<String, dynamic> map) fromMap,
  }) async {
    try {
      data.remove('objectId');
      data.remove('createdAt');
      data.remove('updatedAt');

      final Map<String, dynamic> result = await create(data);

      return fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(
        message: 'mixinCreate',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

mixin DeleteServiceMixin<T> {
  Future<void> mixinDelete({
    required String objectId,
    required Future<void> Function(String objectId) delete,
  }) async {
    try {
      await delete(objectId);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(
        message: 'mixinDelete',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

mixin ListServiceMixin<T> {
  Future<List<T>> mixinList({
    required Future<List<Map<String, dynamic>>> Function() list,
    required T Function(Map<String, dynamic> map) fromMap,
  }) async {
    try {
      final List<Map<String, dynamic>> result = await list();

      final List<T> listData = [];

      for (final json in result) {
        try {
          listData.add(fromMap(json));
        } on BaseException catch (error) {
          Log.baseException(error);
        }
      }

      return listData;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(
        message: 'mixinList',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

mixin UpdateServiceMixin<T> {
  Future<T> mixinUpdate({
    required String objectId,
    required Map<String, dynamic> data,
    required Future<Map<String, dynamic>> Function(
      String objectId, {
      required Map<String, dynamic> data,
    })
    update,
    required T Function(Map<String, dynamic> map) fromMap,
  }) async {
    try {
      data.remove('objectId');
      data.remove('updatedAt');

      final String? createdAt = data.remove('createdAt');

      final Map<String, dynamic> result = await update(objectId, data: data);

      result['objectId'] = objectId;
      result['createdAt'] = createdAt;
      result['updatedAt'] = result['updatedAt'] as String;

      return fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(
        message: 'mixinUpdate',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
