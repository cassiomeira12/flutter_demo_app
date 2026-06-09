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

  final Map<String, dynamic> fakeLocationData = <String, dynamic>{
    'country': 'United States',
    'countryCode': 'US',
    'region': 'VA',
    'regionName': 'Virginia',
    'city': 'Ashburn',
    'zip': '20149',
    'lat': 39.03,
    'lon': -77.5,
    'timezone': 'America/New_York',
    'isp': 'Google LLC',
    'org': 'Google Public DNS',
    'as': 'AS15169 Google LLC',
    'query': '8.8.4.4',
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

  group('Sucesso', () {
    test(
      'deve retornar dados de localização sem informar IP',
      () async {
        final http = AppBinding.find<HttpClient>();
        final dataSource = AppBinding.find<IpAddressLocationDataSource>();

        when(
          () => http.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.POST,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          ),
        ).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: <String, dynamic>{
              'result': fakeLocationData,
            },
          ),
        );

        final result = await dataSource.getIpAddress();

        expect(result, fakeLocationData);
      },
    );

    test(
      'deve retornar dados de localização informando IP fixo',
      () async {
        final http = AppBinding.find<HttpClient>();
        final dataSource = AppBinding.find<IpAddressLocationDataSource>();

        when(
          () => http.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.POST,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          ),
        ).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: <String, dynamic>{
              'result': fakeLocationData,
            },
          ),
        );

        const String ip = '8.8.4.4';
        final result = await dataSource.getIpAddress(ip: ip);

        expect(result, fakeLocationData);
        expect(result['query'], ip);
      },
    );
  });

  group('Erro', () {
    test('deve lançar exceção quando a requisição HTTP falhar', () async {
      final http = AppBinding.find<HttpClient>();
      final dataSource = AppBinding.find<IpAddressLocationDataSource>();

      when(
        () => http.request<Map<String, dynamic>>(
          any(),
          method: HttpMethod.POST,
          useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
          useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
        ),
      ).thenThrow(Exception('Erro na requisição'));

      expect(
        () async => dataSource.getIpAddress(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
