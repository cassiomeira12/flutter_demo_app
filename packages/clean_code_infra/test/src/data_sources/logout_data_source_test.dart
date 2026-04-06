import 'package:clean_code_infra/src/data_sources/data_sources.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    AppBinding.put<LogoutDataSource>(
      LogoutDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
  });

  tearDownAll(() {
    AppBinding.delete<LogoutDataSource>();
    AppBinding.delete<HttpClient>();
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
