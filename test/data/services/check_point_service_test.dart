import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockCheckPointDataSource extends Mock implements CheckPointDataSource {}

void main() {
  late MockCheckPointDataSource mockDataSource;
  late CheckPointServiceImpl service;

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockDataSource = MockCheckPointDataSource();
    service = CheckPointServiceImpl(checkPointDataSource: mockDataSource);
  });

  Map<String, dynamic> createMockJsonPoint({
    int day = 15,
    int month = 5,
    int year = 2026,
    bool today = false,
    bool weekend = false,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    String dateFormatted = '15/05/2026',
    String totalFormatted = '08:00',
    List<Map<String, dynamic>>? workPoints,
    bool hasInconsistency = false,
    String? info,
    String objectId = 'mock-object-id',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'day': day,
      'month': month,
      'year': year,
      'today': today,
      'weekend': weekend,
      'allowance': allowance,
      'holiday': holiday,
      'dayOff': dayOff,
      'dateFormatted': dateFormatted,
      'totalFormatted': totalFormatted,
      'workPoints': workPoints ?? [],
      'hasInconsistency': hasInconsistency,
      'info': info,
      'objectId': objectId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  group('currentPoints', () {
    const month = 5;
    const year = 2026;

    group('Sucesso', () {
      test(
        'deve retornar lista de CheckDayPointEntity quando dataSource retornar dados',
        () async {
          // Arrange
          final mockJson = [
            createMockJsonPoint(day: 1, today: true),
            createMockJsonPoint(day: 2),
            createMockJsonPoint(day: 3),
          ];

          when(
            () => mockDataSource.currentPoints(month: month, year: year),
          ).thenAnswer((_) async => mockJson);

          // Act
          final result = await service.currentPoints(month: month, year: year);

          // Assert
          expect(result, isA<List<CheckDayPointEntity>>());
          expect(result.length, 3);
          expect(result[0].day, 1);
          expect(result[0].today, true);
          expect(result[1].day, 2);
          expect(result[2].day, 3);
          verify(
            () => mockDataSource.currentPoints(month: month, year: year),
          ).called(1);
        },
      );

      test(
        'deve retornar lista vazia quando dataSource retornar lista vazia',
        () async {
          // Arrange
          when(
            () => mockDataSource.currentPoints(month: month, year: year),
          ).thenAnswer((_) async => []);

          // Act
          final result = await service.currentPoints(month: month, year: year);

          // Assert
          expect(result, isA<List<CheckDayPointEntity>>());
          expect(result, isEmpty);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.currentPoints(month: month, year: year),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.currentPoints(month: month, year: year),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.currentPoints(month: month, year: year),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.currentPoints(month: month, year: year),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('registerPoint', () {
    group('Sucesso', () {
      test('deve chamar dataSource e não lançar exceção', () async {
        // Arrange
        when(
          () => mockDataSource.registerPoint(),
        ).thenAnswer((_) async => Future<void>.value());

        // Act
        await service.registerPoint();

        // Assert
        verify(() => mockDataSource.registerPoint()).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.registerPoint(),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.registerPoint(),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.registerPoint(),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.registerPoint(),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('totalHours', () {
    const month = 5;
    const year = 2026;

    group('Sucesso', () {
      test('deve retornar string de horas totais formatadas', () async {
        // Arrange
        const mockTotalHours = '160:30';
        when(
          () => mockDataSource.totalHours(month: month, year: year),
        ).thenAnswer((_) async => mockTotalHours);

        // Act
        final result = await service.totalHours(month: month, year: year);

        // Assert
        expect(result, mockTotalHours);
        verify(
          () => mockDataSource.totalHours(month: month, year: year),
        ).called(1);
      });

      test('deve retornar 00:00 quando não houver horas registradas', () async {
        // Arrange
        const mockTotalHours = '00:00';
        when(
          () => mockDataSource.totalHours(month: month, year: year),
        ).thenAnswer((_) async => mockTotalHours);

        // Act
        final result = await service.totalHours(month: month, year: year);

        // Assert
        expect(result, mockTotalHours);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.totalHours(month: month, year: year),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.totalHours(month: month, year: year),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.totalHours(month: month, year: year),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.totalHours(month: month, year: year),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('updateWorkDay', () {
    const month = 5;
    const year = 2026;
    const day = 15;
    const info = 'Reunião de equipe';

    group('Sucesso', () {
      test('deve retornar CheckDayPointEntity com dados atualizados', () async {
        // Arrange
        final mockJson = createMockJsonPoint(
          info: info,
          allowance: true,
        );

        when(
          () => mockDataSource.updateWorkDay(
            day: day,
            month: month,
            year: year,
            allowance: true,
            info: info,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        final result = await service.updateWorkDay(
          day: day,
          month: month,
          year: year,
          allowance: true,
          info: info,
        );

        // Assert
        expect(result, isA<CheckDayPointEntity>());
        expect(result.day, day);
        expect(result.info, info);
        expect(result.isAllowance, true);
      });

      test('deve passar parâmetros corretamente para dataSource', () async {
        // Arrange
        final mockJson = createMockJsonPoint(
          holiday: true,
        );

        when(
          () => mockDataSource.updateWorkDay(
            day: day,
            month: month,
            year: year,
            holiday: true,
            info: '',
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        await service.updateWorkDay(
          day: day,
          month: month,
          year: year,
          holiday: true,
          info: '',
        );

        // Assert
        verify(
          () => mockDataSource.updateWorkDay(
            day: day,
            month: month,
            year: year,
            holiday: true,
            info: '',
          ),
        ).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkDay(
              day: day,
              month: month,
              year: year,
              info: info,
            ),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.updateWorkDay(
              day: day,
              month: month,
              year: year,
              info: info,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkDay(
              day: day,
              month: month,
              year: year,
              info: info,
            ),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.updateWorkDay(
              day: day,
              month: month,
              year: year,
              info: info,
            ),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('updateHourPoint', () {
    final checkHourPoint = CheckHourPointEntity(
      objectId: 'hour-point-id',
      manual: false,
      valor: null,
    );
    const time = '09:30';

    group('Sucesso', () {
      test('deve retornar CheckDayPointEntity com ponto atualizado', () async {
        // Arrange
        final mockJson = createMockJsonPoint(
          workPoints: [
            {'objectId': 'hour-point-id', 'manual': false, 'time': time},
          ],
        );

        when(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: time,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        final result = await service.updateHourPoint(
          checkHourPoint,
          time: time,
        );

        // Assert
        expect(result, isA<CheckDayPointEntity>());
        expect(result.points.length, 1);
        expect(result.points.first.valor, time);
      });

      test('deve chamar dataSource com objectId correto', () async {
        // Arrange
        final mockJson = createMockJsonPoint();

        when(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: time,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        await service.updateHourPoint(checkHourPoint, time: time);

        // Assert
        verify(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: time,
          ),
        ).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkPoint(
              checkHourPoint.objectId,
              time: time,
            ),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.updateHourPoint(checkHourPoint, time: time),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkPoint(
              checkHourPoint.objectId,
              time: time,
            ),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.updateHourPoint(checkHourPoint, time: time),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('deleteHourPoint', () {
    final checkHourPoint = CheckHourPointEntity(
      objectId: 'hour-point-id',
      manual: true,
      valor: '09:30',
    );

    group('Sucesso', () {
      test('deve retornar CheckDayPointEntity com ponto removido', () async {
        // Arrange
        final mockJson = createMockJsonPoint(workPoints: []);

        when(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: null,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        final result = await service.deleteHourPoint(checkHourPoint);

        // Assert
        expect(result, isA<CheckDayPointEntity>());
        expect(result.points, isEmpty);
      });

      test('deve chamar dataSource com time null', () async {
        // Arrange
        final mockJson = createMockJsonPoint();

        when(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: null,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        await service.deleteHourPoint(checkHourPoint);

        // Assert
        verify(
          () => mockDataSource.updateWorkPoint(
            checkHourPoint.objectId,
            time: null,
          ),
        ).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkPoint(
              checkHourPoint.objectId,
              time: null,
            ),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.deleteHourPoint(checkHourPoint),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.updateWorkPoint(
              checkHourPoint.objectId,
              time: null,
            ),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.deleteHourPoint(checkHourPoint),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('registerCustomPoint', () {
    const month = 5;
    const year = 2026;
    const day = 15;
    const time = '14:00';

    group('Sucesso', () {
      test('deve retornar CheckDayPointEntity com ponto customizado', () async {
        // Arrange
        final mockJson = createMockJsonPoint(
          workPoints: [
            {'objectId': 'custom-id', 'manual': true, 'time': time},
          ],
        );

        when(
          () => mockDataSource.registerCustomPoint(
            day: day,
            month: month,
            year: year,
            time: time,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        final result = await service.registerCustomPoint(
          day: day,
          month: month,
          year: year,
          time: time,
        );

        // Assert
        expect(result, isA<CheckDayPointEntity>());
        expect(result.day, day);
        expect(result.points.length, 1);
        expect(result.points.first.valor, time);
      });

      test('deve passar parâmetros corretos para dataSource', () async {
        // Arrange
        final mockJson = createMockJsonPoint();

        when(
          () => mockDataSource.registerCustomPoint(
            day: day,
            month: month,
            year: year,
            time: time,
          ),
        ).thenAnswer((_) async => mockJson);

        // Act
        await service.registerCustomPoint(
          day: day,
          month: month,
          year: year,
          time: time,
        );

        // Assert
        verify(
          () => mockDataSource.registerCustomPoint(
            day: day,
            month: month,
            year: year,
            time: time,
          ),
        ).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando dataSource lançar HttpException',
        () async {
          // Arrange
          when(
            () => mockDataSource.registerCustomPoint(
              day: day,
              month: month,
              year: year,
              time: time,
            ),
          ).thenThrow(HttpException(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(
            () => service.registerCustomPoint(
              day: day,
              month: month,
              year: year,
              time: time,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar exceção genérica',
        () async {
          // Arrange
          when(
            () => mockDataSource.registerCustomPoint(
              day: day,
              month: month,
              year: year,
              time: time,
            ),
          ).thenThrow(Exception('Generic error'));

          // Act & Assert
          expect(
            () => service.registerCustomPoint(
              day: day,
              month: month,
              year: year,
              time: time,
            ),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });
}
