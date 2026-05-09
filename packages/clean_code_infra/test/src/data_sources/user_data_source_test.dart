import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, dynamic> fakeData = {
    'objectId': 'id',
    'username': 'username',
    'name': 'name',
    'email': 'email',
    'avatarUrl': 'avatarUrl',
    'createdAt': 'createdAt',
    'updatedAt': 'updatedAt',
    'permissions': [],
    'locale': 'locale',
    'sessionToken': 'sessionToken',
    'pushTopics': [],
  };

  setUpAll(() async {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    await DomainModuleBindings().injectDependencies();
    await InfraModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('test getUserData', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<UserDataSource>();

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
          'result': fakeData,
        },
      );
    });

    final result = await datasource.getUserData();

    expect(result, fakeData);
  });

  test('test updateUserData', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<UserDataSource>();

    when(
      () => http.request<Map<String, dynamic>>(
        any(),
        method: HttpMethod.PUT,
        useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
        useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
        useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
      ),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
        data: {},
      );
    });

    final faker = Faker();

    await datasource.updateUserData(
      objectId: faker.guid.guid(),
      data: fakeData,
    );
  });

  test('test deleteUser', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<UserDataSource>();

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

    await datasource.deleteUser(
      reason: faker.lorem.sentence(),
    );
  });

  test('test changePassword', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<UserDataSource>();

    when(
      () => http.post<Map<String, dynamic>>(any()),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
        data: {
          'result': fakeData,
        },
      );
    });

    final faker = Faker();
    final String username = faker.internet.userName();
    final String password = faker.internet.password(length: 6);
    final String newPassword = faker.internet.password(length: 6);

    final result = await datasource.changePassword(
      username: username,
      currentPassword: password,
      newPassword: newPassword,
    );

    expect(result, isNotEmpty);
    expect(result, fakeData);
  });
}
