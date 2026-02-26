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
  Future<List<NotificationEntity>> list() {
    return mixinList(
      list: _dataSource.list,
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
      Log.error('countUnread', error: error, stackTrace: stackTrace);
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
      Log.error('countUnread', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'countUnread',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> testPush({String? title, String? body, String? imageUrl}) async {
    try {
      return await _dataSource.testPush(
        title: title,
        body: body,
        imageUrl: imageUrl,
      );
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('testPush', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'testPush',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
