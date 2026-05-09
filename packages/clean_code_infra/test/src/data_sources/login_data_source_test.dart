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

  test('test login', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<LoginDataSource>();

    when(
      () => http.post<Map<String, dynamic>>(any()),
    ).thenAnswer((_) async {
      return HttpResponse<Map<String, dynamic>>(
        statusCode: 200,
        data: {
          'result': fakeData,
        },
      );
    });

    final faker = Faker();
    final String username = faker.internet.userName();
    final String password = faker.internet.password(length: 6);

    final result = await datasource.login(
      username: username,
      password: password,
    );

    expect(result, fakeData);
  });
}
