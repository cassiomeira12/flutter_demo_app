import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';

class SentryUserFeedbackServiceImpl implements UserFeedbackService {
  @override
  Future<UserFeedbackEntity> create(Map<String, dynamic> data) async {
    try {
      final userFeedback = SentryFeedback(
        name: data['name'],
        contactEmail: data['email'],
        message: data['feedback'],
      );
      final result = await Sentry.captureFeedback(userFeedback);
      result.toString();
      return UserFeedbackEntity(
        objectId: result.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: data['name'],
        email: data['email'],
        feedback: data['feedback'],
      );
    } catch (error, stackTrace) {
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> delete(String objectId) async {}

  @override
  Future<List<UserFeedbackEntity>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) async {
    return [];
  }

  @override
  UserFeedbackEntity parseMap(Map<String, dynamic> map) {
    return UserFeedbackEntity(
      objectId: map['objectId'],
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.tryParse(map['createdAt']),
      updatedAt: map['updatedAt'] == null
          ? null
          : DateTime.tryParse(map['updatedAt']),
      name: map['name'],
      email: map['email'],
      feedback: map['feedback'],
    );
  }

  @override
  Future<UserFeedbackEntity> read(String objectId) {
    throw UnimplementedError();
  }

  @override
  Future<UserFeedbackEntity> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) {
    throw UnimplementedError();
  }
}
