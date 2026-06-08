import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock for IpAddressLocationDataSource
class MockIpAddressLocationDataSource extends Mock
    implements IpAddressLocationDataSource {}

void main() {
  late MockIpAddressLocationDataSource mockDataSource;
  late IpAddressLocationServiceImpl service;

  setUp(() {
    mockDataSource = MockIpAddressLocationDataSource();
    service = IpAddressLocationServiceImpl(
      ipAddressLocationDataSource: mockDataSource,
    );
  });

  group('IpAddressLocationServiceImpl - getIpAddress', () {
    group('Sucesso', () {
      test(
        'deve retornar IpAddressLocationEntity quando dataSource retorna dados válidos',
        () async {
          // arrange
          final mockResponse = <String, dynamic>{
            'country': 'Brazil',
            'countryCode': 'BR',
            'region': 'SP',
            'regionName': 'São Paulo',
            'city': 'São Paulo',
            'zip': '01000',
            'lat': -23.5505,
            'lon': -46.6333,
            'timezone': 'America/Sao_Paulo',
            'isp': 'Telefonica Brasil',
            'org': 'Telefonica Brasil',
            'as': 'AS8151',
            'query': '200.100.100.1',
          };
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenAnswer((_) async => mockResponse);
          // act
          final result = await service.getIpAddress();
          // assert
          expect(result, isA<IpAddressLocationEntity>());
          expect(result.country, 'Brazil');
          expect(result.countryCode, 'BR');
          expect(result.city, 'São Paulo');
          expect(result.ip, '200.100.100.1');
        },
      );

      test(
        'deve retornar IpAddressLocationEntity com IP específico quando passado como parâmetro',
        () async {
          // arrange
          final mockResponse = <String, dynamic>{
            'country': 'United States',
            'countryCode': 'US',
            'region': 'CA',
            'regionName': 'California',
            'city': 'Mountain View',
            'zip': '94043',
            'lat': 37.3861,
            'lon': -122.0838,
            'timezone': 'America/Los_Angeles',
            'isp': 'Google LLC',
            'org': 'Google LLC',
            'as': 'AS15169',
            'query': '8.8.8.8',
          };
          when(
            () => mockDataSource.getIpAddress(ip: '8.8.8.8'),
          ).thenAnswer((_) async => mockResponse);
          // act
          final result = await service.getIpAddress(ip: '8.8.8.8');
          // assert
          expect(result, isA<IpAddressLocationEntity>());
          expect(result.ip, '8.8.8.8');
          expect(result.country, 'United States');
          expect(result.isp, 'Google LLC');
        },
      );

      test(
        'deve retornar entity com dados nulos quando API retornar campos vazios',
        () async {
          // arrange
          final mockResponse = <String, dynamic>{
            'country': null,
            'countryCode': null,
            'region': null,
            'regionName': null,
            'city': null,
            'zip': null,
            'lat': null,
            'lon': null,
            'timezone': null,
            'isp': null,
            'org': null,
            'as': null,
            'query': null,
          };
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenAnswer((_) async => mockResponse);
          // act
          final result = await service.getIpAddress();
          // assert
          expect(result, isA<IpAddressLocationEntity>());
          expect(result.country, isNull);
          expect(result.ip, isNull);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // arrange
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenThrow(HttpException(statusCode: 500, message: 'Network error'));
          // act & assert
          expect(
            () => service.getIpAddress(),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar BaseException',
        () async {
          // arrange
          final baseException = BaseException(
            error: Exception('Service unavailable'),
          );
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenThrow(baseException);
          // act & assert
          expect(
            () => service.getIpAddress(),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando ocorrer erro genérico na dataSource',
        () async {
          // arrange
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenThrow(Exception('Unknown error'));
          // act & assert
          expect(
            () => service.getIpAddress(),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test(
        'deve relançar BaseException quando dataSource já lançou BaseException',
        () async {
          // arrange
          final originalException = BaseException(
            error: Exception('Original error'),
          );
          when(
            () => mockDataSource.getIpAddress(ip: any(named: 'ip')),
          ).thenThrow(originalException);
          // act & assert
          expect(
            () => service.getIpAddress(),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });
}
