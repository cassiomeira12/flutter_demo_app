import 'package:admin/src/data/data.dart';
import 'package:admin/src/infra/infra.dart';
import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, dynamic> fakeData = {
    'website': 'website',
    'ip': 'ip',
    'userAgent': 'userAgent',
    'country': 'country',
    'countryCode': 'countryCode',
    'countryFlag': 'countryFlag',
    'region': 'region',
    'regionName': 'regionName',
    'city': 'city',
    'zip': 'zip',
    'lat': 1.0,
    'lon': 1.0,
    'timezone': 'timezone',
    'isp': 'isp',
    'org': 'org',
    'ispOrg': 'ispOrg',
    'objectId': 'id',
    'createdAt': 'createdAt',
    'updatedAt': 'updatedAt',
  };

  setUpAll(() async {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    AppBinding.put<WebVisitHistoryDataSource>(
      WebVisitHistoryDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('test list', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<WebVisitHistoryDataSource>();

    when(
      () => http.request<Map<String, dynamic>>(
        any(),
        method: HttpMethod.GET,
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
}
