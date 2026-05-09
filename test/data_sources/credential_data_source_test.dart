import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/infra/data_sources/data_sources.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HttpClientMock mockHttpClient;
  late CredentialDataSourceImpl credentialDataSource;

  final Map<String, dynamic> fakeCredentialData = {
    'objectId': 'credential-123',
    'username': 'testuser',
    'password': 'encrypted_password',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  final List<Map<String, dynamic>> fakeCredentialList = [
    fakeCredentialData,
  ];

  setUpAll(() async {
    registerFallbackValue(HttpRequestFake());
  });

  setUp(() {
    mockHttpClient = HttpClientMock();
    credentialDataSource = CredentialDataSourceImpl(
      http: mockHttpClient,
    );
  });

  group('CredentialDataSourceImpl - create', () {
    test(
      'deve retornar dados da credencial quando create for bem-sucedido',
      () async {
        when(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.POST,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
            useRefreshTokenInterceptor: any(
              named: 'useRefreshTokenInterceptor',
            ),
          ),
        ).thenAnswer((_) async {
          return HttpResponse<Map<String, dynamic>>(
            statusCode: 201,
            data: {
              'result': fakeCredentialData,
            },
          );
        });

        final result = await credentialDataSource.create(fakeCredentialData);

        expect(result, isA<Map<String, dynamic>>());
        expect(result['objectId'], 'credential-123');
        expect(result['username'], 'testuser');

        verify(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.POST,
            useDefaultBaseUrl: true,
            useDefaultInterceptors: true,
          ),
        ).called(1);
      },
    );

    test('deve lançar exceção quando http.request falhar', () async {
      when(
        () => mockHttpClient.request<Map<String, dynamic>>(
          any(),
          method: HttpMethod.POST,
          useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
          useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
        ),
      ).thenThrow(Exception('Network error'));

      expect(
        () => credentialDataSource.create(fakeCredentialData),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('CredentialDataSourceImpl - delete', () {
    test(
      'deve executar delete com sucesso quando objectId for válido',
      () async {
        when(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.DELETE,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
            useRefreshTokenInterceptor: any(
              named: 'useRefreshTokenInterceptor',
            ),
          ),
        ).thenAnswer((_) async {
          return HttpResponse<Map<String, dynamic>>(
            statusCode: 204,
            data: {},
          );
        });

        await credentialDataSource.delete('credential-123');

        verify(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.DELETE,
            useDefaultBaseUrl: true,
            useDefaultInterceptors: true,
          ),
        ).called(1);
      },
    );

    test('deve lançar exceção quando http.request falhar no delete', () async {
      when(
        () => mockHttpClient.request<Map<String, dynamic>>(
          any(),
          method: HttpMethod.DELETE,
          useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
          useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
        ),
      ).thenThrow(Exception('Delete failed'));

      expect(
        () => credentialDataSource.delete('credential-123'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('CredentialDataSourceImpl - list', () {
    test(
      'deve retornar lista de credenciais quando list for bem-sucedido',
      () async {
        when(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.GET,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
            useRefreshTokenInterceptor: any(
              named: 'useRefreshTokenInterceptor',
            ),
          ),
        ).thenAnswer((_) async {
          return HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'results': fakeCredentialList,
            },
          );
        });

        final result = await credentialDataSource.list();

        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result.first['objectId'], 'credential-123');

        verify(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.GET,
            useDefaultBaseUrl: true,
            useDefaultInterceptors: true,
          ),
        ).called(1);
      },
    );

    test('deve retornar lista vazia quando não houver credenciais', () async {
      when(
        () => mockHttpClient.request<Map<String, dynamic>>(
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
            'results': <Map<String, dynamic>>[],
          },
        );
      });

      final result = await credentialDataSource.list();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.isEmpty, true);
    });

    test('deve lançar exceção quando http.request falhar no list', () async {
      when(
        () => mockHttpClient.request<Map<String, dynamic>>(
          any(),
          method: HttpMethod.GET,
          useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
          useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
        ),
      ).thenThrow(Exception('List failed'));

      expect(
        () => credentialDataSource.list(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('CredentialDataSourceImpl - update', () {
    test(
      'deve retornar dados atualizados quando update for bem-sucedido',
      () async {
        final updatedData = {
          ...fakeCredentialData,
          'username': 'updateduser',
        };

        when(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.PUT,
            useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
            useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
            useRefreshTokenInterceptor: any(
              named: 'useRefreshTokenInterceptor',
            ),
          ),
        ).thenAnswer((_) async {
          return HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': updatedData,
            },
          );
        });

        final result = await credentialDataSource.update(
          'credential-123',
          data: updatedData,
        );

        expect(result, isA<Map<String, dynamic>>());
        expect(result['username'], 'updateduser');

        verify(
          () => mockHttpClient.request<Map<String, dynamic>>(
            any(),
            method: HttpMethod.PUT,
            useDefaultBaseUrl: true,
            useDefaultInterceptors: true,
          ),
        ).called(1);
      },
    );

    test('deve lançar exceção quando http.request falhar no update', () async {
      when(
        () => mockHttpClient.request<Map<String, dynamic>>(
          any(),
          method: HttpMethod.PUT,
          useDefaultBaseUrl: any(named: 'useDefaultBaseUrl'),
          useDefaultInterceptors: any(named: 'useDefaultInterceptors'),
          useRefreshTokenInterceptor: any(named: 'useRefreshTokenInterceptor'),
        ),
      ).thenThrow(Exception('Update failed'));

      expect(
        () => credentialDataSource.update(
          'credential-123',
          data: fakeCredentialData,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('CredentialDataSourceImpl - read', () {
    test('deve lançar UnimplementedError quando read for chamado', () async {
      expect(
        () => credentialDataSource.read('credential-123'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
