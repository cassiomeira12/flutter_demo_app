import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    await DomainModuleBindings().injectDependencies();
    await InfraModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('test logout', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<LogoutDataSource>();

    when(
      () => http.post(any()),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 200,
      );
    });

    await datasource.logout();
  });
}
