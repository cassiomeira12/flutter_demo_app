import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

class NotificationDataSourceImpl
    with CreateDataSourceMixin, ListDataSourceMixin
    implements NotificationDataSource {
  final HttpClient _http;

  NotificationDataSourceImpl({required this._http});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final request = HttpRequest(
      url: EndpointsEnum.createNotification.endpoint,
      data: data,
    );

    return await mixinCreate(
      http: _http,
      request: request,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) async {
    final Map<String, dynamic> parameters = {
      'limit': limit,
      'skip': skip,
      'order': order,
    };

    if (where != null) parameters['where'] = where;

    final request = HttpRequest(
      url: EndpointsEnum.listNotification.endpoint,
      queryParameters: parameters,
    );

    return await mixinList(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }

  @override
  Future<int> countUnread(String userId) async {
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
      data: {
        'query': stringMutation,
      },
    );

    final response = await _http.post<Map<String, dynamic>>(request);

    final Map<String, dynamic> json = response.data!;

    return json['data']['notifications']['count'] as int;
  }

  @override
  Future<void> readNotifications(String notificationId) async {
    final request = HttpRequest(
      url: EndpointsEnum.readNotification.endpoint,
      data: {
        'notificationId': notificationId,
      },
    );

    await _http.post(request);
  }

  @override
  Future<void> testPush(BaseUseCaseParam? param) async {
    final request = HttpRequest(
      url: EndpointsEnum.testPushNotification.endpoint,
      data: param?.toMap(),
    );

    await _http.post(request);
  }
}
