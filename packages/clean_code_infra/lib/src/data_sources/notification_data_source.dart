import 'package:clean_code_data/clean_code_data.dart';

class NotificationDataSourceImpl
    with CreateDataSourceMixin, ListDataSourceMixin
    implements NotificationDataSource {
  final HttpClient _http;

  NotificationDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final request = HttpRequest(
      url: EndpointsEnum.createNotification.endpoint,
      data: data,
    );

    return await mixinCreate(http: _http, request: request);
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    final request = HttpRequest(url: EndpointsEnum.listNotification.endpoint);

    return await mixinList(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }

  @override
  Future<int> countUnread(String userId) async {
    try {
      final String stringMutation =
          '''
        query unreadNotifications {
          notifications(
            where: {
              recipient: {
                have: {
                  objectId: {
                    equalTo: "$userId"
                  }
                }
              },
              viewed: {
                equalTo: false
              },
            },
          ) {
            count
          }
        }
      ''';

      final request = HttpRequest(
        url: EndpointsEnum.graphql.endpoint,
        data: {'query': stringMutation},
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['data']['notifications']['count'] as int;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> readNotifications(String notificationId) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.readNotification.endpoint,
        data: {'notificationId': notificationId},
      );

      await _http.post(request);
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> testPush({String? title, String? body, String? imageUrl}) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.testPushNotification.endpoint,
        data: {'title': title, 'body': body, 'imageUrl': imageUrl},
      );

      await _http.post(request);
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
