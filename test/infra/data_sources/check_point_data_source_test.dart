import 'package:clean_code_data/clean_code_data.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/infra/data_sources/check_point_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

class HttpRequestFake extends Fake implements HttpRequest {}

void main() {
  late HttpClientMock mockHttpClient;
  late CheckPointDataSourceImpl subject;

  setUpAll(() {
    registerFallbackValue(HttpRequestFake());
  });

  setUp(() {
    mockHttpClient = HttpClientMock();
    subject = CheckPointDataSourceImpl(http: mockHttpClient);
  });

  group('currentPoints', () {
    const month = 5;
    const year = 2026;

    test(
      'deve retornar lista de pontos quando a requisição for bem-sucedida',
      () async {
        // arrange
        final List<Map<String, dynamic>> expectedResult = [
          {'objectId': '1', 'time': '09:00'},
          {'objectId': '2', 'time': '10:00'},
        ];

        when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': expectedResult,
            },
          ),
        );

        // act
        final result = await subject.currentPoints(month: month, year: year);

        // assert
        expect(result, expectedResult);
        verify(
          () => mockHttpClient.post<Map<String, dynamic>>(any()),
        ).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.currentPoints(month: month, year: year),
        throwsA(isA<Exception>()),
      );
    });

    test('deve retornar lista vazia quando result for null', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => HttpResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = await subject.currentPoints(month: month, year: year);

      // assert
      expect(result, isEmpty);
    });
  });

  group('registerPoint', () {
    test(
      'deve completar sem erro quando a requisição for bem-sucedida',
      () async {
        // arrange
        when(() => mockHttpClient.post<dynamic>(any())).thenAnswer(
          (_) async => HttpResponse<dynamic>(
            statusCode: 200,
          ),
        );

        // act
        await subject.registerPoint();

        // assert
        verify(() => mockHttpClient.post<dynamic>(any())).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<dynamic>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.registerPoint(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('totalHours', () {
    const month = 5;
    const year = 2026;

    test(
      'deve retornar total de horas formatado quando a requisição for bem-sucedida',
      () async {
        // arrange
        const expectedTotal = '08:30';

        when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': {
                'totalFormatted': expectedTotal,
              },
            },
          ),
        );

        // act
        final result = await subject.totalHours(month: month, year: year);

        // assert
        expect(result, expectedTotal);
        verify(
          () => mockHttpClient.post<Map<String, dynamic>>(any()),
        ).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.totalHours(month: month, year: year),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateWorkPoint', () {
    const objectId = 'point-123';
    const time = '09:30';

    test(
      'deve retornar resultado quando a requisição for bem-sucedida',
      () async {
        // arrange
        final expectedResult = {
          'objectId': objectId,
          'time': time,
          'success': true,
        };

        when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': expectedResult,
            },
          ),
        );

        // act
        final result = await subject.updateWorkPoint(objectId, time: time);

        // assert
        expect(result, expectedResult);
        verify(
          () => mockHttpClient.post<Map<String, dynamic>>(any()),
        ).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.updateWorkPoint(objectId, time: time),
        throwsA(isA<Exception>()),
      );
    });

    test('deve funcionar com time null', () async {
      // arrange
      final expectedResult = {
        'objectId': objectId,
        'time': null,
        'success': true,
      };

      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => HttpResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: {
            'result': expectedResult,
          },
        ),
      );

      // act
      final result = await subject.updateWorkPoint(objectId, time: null);

      // assert
      expect(result, expectedResult);
    });
  });

  group('registerCustomPoint', () {
    const day = 15;
    const month = 5;
    const year = 2026;
    const time = '14:00';

    test(
      'deve retornar resultado quando a requisição for bem-sucedida',
      () async {
        // arrange
        final expectedResult = {
          'day': day,
          'month': month,
          'year': year,
          'time': time,
          'success': true,
        };

        when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': expectedResult,
            },
          ),
        );

        // act
        final result = await subject.registerCustomPoint(
          day: day,
          month: month,
          year: year,
          time: time,
        );

        // assert
        expect(result, expectedResult);
        verify(
          () => mockHttpClient.post<Map<String, dynamic>>(any()),
        ).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.registerCustomPoint(
          day: day,
          month: month,
          year: year,
          time: time,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deve funcionar com time null', () async {
      // arrange
      final expectedResult = {
        'day': day,
        'month': month,
        'year': year,
        'time': null,
        'success': true,
      };

      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => HttpResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: {
            'result': expectedResult,
          },
        ),
      );

      // act
      final result = await subject.registerCustomPoint(
        day: day,
        month: month,
        year: year,
        time: null,
      );

      // assert
      expect(result, expectedResult);
    });
  });

  group('updateWorkDay', () {
    const day = 15;
    const month = 5;
    const year = 2026;
    const info = 'Work from home';

    test(
      'deve retornar resultado quando a requisição for bem-sucedida',
      () async {
        // arrange
        final expectedResult = {
          'day': day,
          'month': month,
          'year': year,
          'allowance': false,
          'holiday': false,
          'dayOff': false,
          'info': info,
          'success': true,
        };

        when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => HttpResponse<Map<String, dynamic>>(
            statusCode: 200,
            data: {
              'result': expectedResult,
            },
          ),
        );

        // act
        final result = await subject.updateWorkDay(
          day: day,
          month: month,
          year: year,
          info: info,
        );

        // assert
        expect(result, expectedResult);
        verify(
          () => mockHttpClient.post<Map<String, dynamic>>(any()),
        ).called(1);
      },
    );

    test('deve lançar exceção quando a requisição falhar', () async {
      // arrange
      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenThrow(
        Exception('Network error'),
      );

      // act & assert
      expect(
        () => subject.updateWorkDay(
          day: day,
          month: month,
          year: year,
          info: info,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deve enviar todos os parâmetros booleanos corretamente', () async {
      // arrange
      final expectedResult = {
        'day': day,
        'success': true,
      };

      when(() => mockHttpClient.post<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => HttpResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: {
            'result': expectedResult,
          },
        ),
      );

      // act
      final result = await subject.updateWorkDay(
        day: day,
        month: month,
        year: year,
        allowance: true,
        holiday: true,
        dayOff: true,
        info: info,
      );

      // assert
      expect(result, expectedResult);
    });
  });
}
