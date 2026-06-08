import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, dynamic> fakeData = {
    'installationId': 'installationId',
    'appName': 'appName',
    'appVersion': 'appVersion',
    'appIdentifier': 'appIdentifier',
    'channels': 'channels',
    'GCMSenderId': 'gcmSenderId',
    'deviceToken': 'deviceToken',
    'pushType': 'pushType',
    'deviceId': 'deviceId',
    'deviceBrand': 'deviceBrand',
    'deviceModel': 'deviceModel',
    'deviceType': 'deviceType',
    'deviceOsVersion': 'deviceOsVersion',
    'timeZone': 'timeZone',
    'localeIdentifier': 'localeIdentifier',
    'platform': 'platform',
    'ip': 'ip',
  };

  setUpAll(() async {
    registerFallbackValue(HttpRequestFake());

    AppBinding.put<HttpClient>(HttpClientMock());

    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('test create app installation', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<AppInstallationDataSource>();

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

  test('test list app installation', () async {
    final http = AppBinding.find<HttpClient>();
    final datasource = AppBinding.find<AppInstallationDataSource>();

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
          'result': [fakeData],
        },
      );
    });

    final faker = Faker();

    final result = await datasource.list(faker.guid.guid());

    expect(result.isNotEmpty, true);
    expect(result.first, fakeData);
  });
}
