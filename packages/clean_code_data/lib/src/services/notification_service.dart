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
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }

  @override
  Future<void> readNotifications(NotificationEntity notification) async {
    try {
      return await _dataSource.readNotifications(notification.objectId);
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
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
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
