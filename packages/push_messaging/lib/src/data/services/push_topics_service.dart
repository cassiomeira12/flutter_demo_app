import 'package:core/core.dart';
import 'package:push_messaging/src/data/data.dart';
import 'package:push_messaging/src/domain/domain.dart';

class PushTopicsServiceImpl implements PushTopicsService {
  final PushTopicsDataSource _dataSource;

  PushTopicsServiceImpl({
    required PushTopicsDataSource pushTopicsDataSource,
  }) : _dataSource = pushTopicsDataSource;

  @override
  Future<void> subscribeTopic(List<String> topics) async {
    try {
      await _dataSource.subscribeTopic(topics);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<void> unsubscribeTopic(List<String> topics) async {
    try {
      await _dataSource.unsubscribeTopic(topics);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<void> subscribeUserTopic(String topic) async {
    try {
      await _dataSource.subscribeUserTopic(topic);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<void> unsubscribeUserTopic(String topic) async {
    try {
      await _dataSource.unsubscribeUserTopic(topic);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      throw BaseException();
    }
  }
}
