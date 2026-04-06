import 'package:core/core.dart';

class NotificationServiceImpl
    with
        CreateServiceMixin<NotificationEntity>,
        ListServiceMixin<NotificationEntity>
    implements NotificationService {
  final NotificationDataSource _dataSource;

  NotificationServiceImpl({
    required NotificationDataSource notificationDataSource,
  }) : _dataSource = notificationDataSource;

  @override
  Future<NotificationEntity> create(Map<String, dynamic> data) {
    return mixinCreate(
      data: data,
      create: _dataSource.create,
      fromMap: NotificationModel.fromMap,
    );
  }

  @override
  Future<List<NotificationEntity>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) {
    return mixinList(
      list: () => _dataSource.list(
        limit: limit,
        skip: skip,
        order: order,
        where: where,
      ),
      fromMap: NotificationModel.fromMap,
    );
  }

  @override
  Future<int> countUnread(UserEntity user) async {
    try {
      return await _dataSource.countUnread(user.id);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException(
        message: 'countUnread',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> readNotifications(NotificationEntity notification) async {
    try {
      return await _dataSource.readNotifications(notification.objectId);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException(
        message: 'readNotifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> testPush(TestPushNotificationDto? param) async {
    try {
      await _dataSource.testPush(param);
      return const Success();
    } on HttpException catch (error, stackTrace) {
      try {
        throw ExceptionHelper.call(error, stackTrace: stackTrace);
      } on BaseException catch (error) {
        return Error(error);
      }
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
