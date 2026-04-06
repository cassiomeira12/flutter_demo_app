import 'package:clean_code_infra/src/data_sources/data_sources.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

class BaseUseCaseParamFake extends Fake implements BaseUseCaseParam {
  @override
  Map<String, dynamic> toMap() {
    return {
      'title': 'title',
      'body': 'body',
      'imageUrl': 'imageUrl',
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, dynamic> fakeData = {
    'objectId': 'objectId',
    'title': 'title',
    'body': 'body',
    'viewed': 'viewed',
    'imageUrl': 'imageUrl',
  };

  setUpAll(() {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    AppBinding.put<NotificationDataSource>(
      NotificationDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
  });

  tearDownAll(() {
    AppBinding.delete<NotificationDataSource>();
    AppBinding.delete<HttpClient>();
  });

  test('test create notification', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<NotificationDataSource>();

    when(
      () => http.request<Map<String, dynamic>>(
        any(),
        method: HttpMethod.POST,
        useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
        useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
        useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
      ),
    ).thenAnswer((_) async {
      return HttpResponse<Map<String, dynamic>>(
        statusCode: 201,
        data: {
          'result': fakeData,
        },
      );
    });

    final result = await datasource.create(fakeData);

    expect(result, fakeData);
  });

  test('test list notifications', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<NotificationDataSource>();

    when(
      () => http.request<Map<String, dynamic>>(
        any(),
        method: HttpMethod.POST,
        useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
        useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
        useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
      ),
    ).thenAnswer((_) async {
      return HttpResponse<Map<String, dynamic>>(
        statusCode: 200,
        data: {
          'results': [fakeData],
        },
      );
    });

    final result = await datasource.list();

    expect(result.isNotEmpty, true);
    expect(result.first, fakeData);
  });

  test('test count unread', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<NotificationDataSource>();

    const int fakeCount = 1;

    when(
      () => http.post<Map<String, dynamic>>(any()),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
        data: {
          'data': {
            'notifications': {
              'count': fakeCount,
            },
          },
        },
      );
    });

    final faker = Faker();

    final int count = await datasource.countUnread(faker.guid.guid());

    expect(count, fakeCount);
  });

  test('test read notifications', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<NotificationDataSource>();

    when(
      () => http.post(any()),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
      );
    });

    final faker = Faker();

    await datasource.readNotifications(faker.guid.guid());
  });

  test('test push', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<NotificationDataSource>();

    when(
      () => http.post(any()),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
      );
    });

    await datasource.testPush(BaseUseCaseParamFake());
  });
}
