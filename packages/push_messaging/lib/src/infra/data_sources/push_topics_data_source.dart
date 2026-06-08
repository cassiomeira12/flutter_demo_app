import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:push_messaging/src/data/data.dart';

class PushTopicsDataSourceImpl implements PushTopicsDataSource {
  final HttpClient _http;

  PushTopicsDataSourceImpl({required this._http});

  @override
  Future<void> subscribeTopic(List<String> topics) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.subscribeTopic.endpoint,
        data: {
          'topics': topics,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;
      final List<String> subscribedTopics = List.from(json['result'] ?? []);

      for (final topic in topics) {
        if (!subscribedTopics.contains(topic)) {
          throw BaseException(message: 'topic_not_registered');
        }
      }
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> unsubscribeTopic(List<String> topics) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.unsubscribeTopic.endpoint,
        data: {
          'topics': topics,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;
      final List<String> subscribedTopics = List.from(json['result'] ?? []);

      for (final topic in topics) {
        if (subscribedTopics.contains(topic)) {
          throw BaseException(message: 'topic_already_registered');
        }
      }
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> subscribeUserTopic(String topic) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.subscribeUserTopic.endpoint,
        data: {
          'topic': topic,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      if (!List.from(json['result'] ?? []).contains(topic)) {
        throw BaseException(message: 'topic_not_registered');
      }
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> unsubscribeUserTopic(String topic) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.unsubscribeUserTopic.endpoint,
        data: {
          'topic': topic,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      if (List.from(json['result'] ?? []).contains(topic)) {
        throw BaseException(message: 'topic_already_registered');
      }
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
