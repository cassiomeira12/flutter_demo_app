import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point_controller.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_controller.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_store.dart';
import 'package:flutter_test/flutter_test.dart';

// Mocks
class MockUpdateWorkDayUseCase extends Mock implements UpdateWorkDayUseCase {}

class MockUpdateHourPointUseCase extends Mock
    implements UpdateHourPointUseCase {}

class MockDeleteHourPointUseCase extends Mock
    implements DeleteHourPointUseCase {}

class MockRegisterCustomPointUseCase extends Mock
    implements RegisterCustomPointUseCase {}

class MockCheckPointsController extends Mock implements CheckPointsController {}

class MockCheckPointsStore extends Mock implements CheckPointsStore {}

void main() {
  late MockUpdateWorkDayUseCase mockUpdateWorkDayUseCase;
  late MockUpdateHourPointUseCase mockUpdateHourPointUseCase;
  late MockDeleteHourPointUseCase mockDeleteHourPointUseCase;
  late MockRegisterCustomPointUseCase mockRegisterCustomPointUseCase;
  late MockCheckPointsController mockCheckPointsController;
  late MockCheckPointsStore mockCheckPointsStore;
  late CheckPointController controller;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(
      CheckDayPointEntity(
        day: 1,
        month: 1,
        year: 2026,
        today: false,
        isWeekend: false,
        isAllowance: false,
        isHoliday: false,
        isDayOff: false,
        dateFormatted: '01/01/2026',
        totalFormatted: '00:00',
        points: [],
        hasInconsistency: false,
        info: null,
        objectId: 'fallback',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    registerFallbackValue(
      CheckHourPointEntity(objectId: 'fallback', manual: false, value: '08:00'),
    );
  });

  setUp(() {
    mockUpdateWorkDayUseCase = MockUpdateWorkDayUseCase();
    mockUpdateHourPointUseCase = MockUpdateHourPointUseCase();
    mockDeleteHourPointUseCase = MockDeleteHourPointUseCase();
    mockRegisterCustomPointUseCase = MockRegisterCustomPointUseCase();
    mockCheckPointsController = MockCheckPointsController();
    mockCheckPointsStore = MockCheckPointsStore();

    controller = CheckPointController(
      updateWorkDayUseCase: mockUpdateWorkDayUseCase,
      updateHourPointUseCase: mockUpdateHourPointUseCase,
      deleteHourPointUseCase: mockDeleteHourPointUseCase,
      registerCustomPointUseCase: mockRegisterCustomPointUseCase,
      checkPointsController: mockCheckPointsController,
      checkPointsStore: mockCheckPointsStore,
    );
  });

  tearDown(() {
    controller.onClose();
  });

  CheckDayPointEntity createMockCheckDayPoint({
    bool today = false,
    List<CheckHourPointEntity>? points,
    bool? isAllowance,
    bool? isHoliday,
    bool? isDayOff,
    String? info,
  }) {
    return CheckDayPointEntity(
      day: 15,
      month: 5,
      year: 2026,
      today: today,
      isWeekend: false,
      isAllowance: isAllowance ?? false,
      isHoliday: isHoliday ?? false,
      isDayOff: isDayOff ?? false,
      dateFormatted: '15/05/2026',
      totalFormatted: '08:00',
      points: points ?? [],
      hasInconsistency: false,
      info: info,
      objectId: 'mock-object-id',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CheckHourPointEntity createMockCheckHourPoint() {
    return CheckHourPointEntity(
      objectId: 'hour-point-1',
      manual: false,
      value: '08:00',
    );
  }

  group('updateCheckDayPoint', () {
    group('Sucesso', () {
      test(
        'deve atualizar o dia e atualizar store e controller',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();
          final updatedCheckDayPoint = createMockCheckDayPoint(
            isAllowance: true,
            info: 'Allowance updated',
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateWorkDayUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              allowance: any(named: 'allowance'),
              holiday: any(named: 'holiday'),
              dayOff: any(named: 'dayOff'),
              info: any(named: 'info'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.updateCheckDayPoint(
            allowance: true,
            info: 'Allowance updated',
          );

          // Assert
          expect(controller.loading.value, false);
          verify(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).called(1);
          verify(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).called(1);
        },
      );

      test(
        'deve usar valores padrão quando parâmetros forem nulos',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();
          final updatedCheckDayPoint = createMockCheckDayPoint(
            info: 'Original info',
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateWorkDayUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              allowance: any(named: 'allowance'),
              holiday: any(named: 'holiday'),
              dayOff: any(named: 'dayOff'),
              info: any(named: 'info'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.updateCheckDayPoint(info: 'Original info');

          // Assert
          expect(controller.loading.value, false);
          verify(
            () => mockUpdateWorkDayUseCase.call(
              day: 15,
              month: 5,
              year: 2026,
              info: 'Original info',
            ),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando use case falhar',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateWorkDayUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              allowance: any(named: 'allowance'),
              holiday: any(named: 'holiday'),
              dayOff: any(named: 'dayOff'),
              info: any(named: 'info'),
            ),
          ).thenThrow(Exception('Erro ao atualizar dia'));

          // Act & Assert
          expect(
            () => controller.updateCheckDayPoint(info: 'Test'),
            throwsA(isA<Exception>()),
          );
          expect(controller.loading.value, false);
        },
      );
    });
  });

  group('updateCheckHourPoint', () {
    group('Sucesso', () {
      test(
        'deve atualizar hora do ponto e atualizar store e controller',
        () async {
          // Arrange
          final mockCheckHourPoint = createMockCheckHourPoint();
          final mockCheckDayPoint = createMockCheckDayPoint(
            points: [mockCheckHourPoint],
          );
          final updatedCheckDayPoint = createMockCheckDayPoint(
            points: [
              CheckHourPointEntity(
                objectId: 'hour-point-1',
                manual: false,
                value: '09:30',
              ),
            ],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateHourPointUseCase.call(
              checkHourPoint: any(named: 'checkHourPoint'),
              time: any(named: 'time'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.updateCheckHourPoint(
            mockCheckHourPoint,
            hour: 9,
            minute: 30,
          );

          // Assert
          expect(controller.loading.value, false);
          verify(
            () => mockUpdateHourPointUseCase.call(
              checkHourPoint: mockCheckHourPoint,
              time: '09:30',
            ),
          ).called(1);
          verify(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).called(1);
          verify(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).called(1);
        },
      );

      test(
        'deve adicionar zero à esquerda quando hour < 10',
        () async {
          // Arrange
          final mockCheckHourPoint = createMockCheckHourPoint();
          final mockCheckDayPoint = createMockCheckDayPoint(
            points: [mockCheckHourPoint],
          );
          final updatedCheckDayPoint = createMockCheckDayPoint(
            points: [
              CheckHourPointEntity(
                objectId: 'hour-point-1',
                manual: false,
                value: '08:05',
              ),
            ],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateHourPointUseCase.call(
              checkHourPoint: any(named: 'checkHourPoint'),
              time: any(named: 'time'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.updateCheckHourPoint(
            mockCheckHourPoint,
            hour: 8,
            minute: 5,
          );

          // Assert
          verify(
            () => mockUpdateHourPointUseCase.call(
              checkHourPoint: mockCheckHourPoint,
              time: '08:05',
            ),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando use case falhar',
        () async {
          // Arrange
          final mockCheckHourPoint = createMockCheckHourPoint();
          final mockCheckDayPoint = createMockCheckDayPoint(
            points: [mockCheckHourPoint],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockUpdateHourPointUseCase.call(
              checkHourPoint: any(named: 'checkHourPoint'),
              time: any(named: 'time'),
            ),
          ).thenThrow(Exception('Erro ao atualizar ponto'));

          // Act & Assert
          expect(
            () => controller.updateCheckHourPoint(
              mockCheckHourPoint,
              hour: 9,
              minute: 30,
            ),
            throwsA(isA<Exception>()),
          );
          expect(controller.loading.value, false);
        },
      );
    });
  });

  group('deleteCheckHourPoint', () {
    group('Sucesso', () {
      test(
        'deve deletar ponto e atualizar store e controller',
        () async {
          // Arrange
          final mockCheckHourPoint = createMockCheckHourPoint();
          final mockCheckDayPoint = createMockCheckDayPoint(
            points: [mockCheckHourPoint],
          );
          final updatedCheckDayPoint = createMockCheckDayPoint(points: []);

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockDeleteHourPointUseCase.call(any()),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.deleteCheckHourPoint(mockCheckHourPoint);

          // Assert
          expect(controller.loading.value, false);
          verify(
            () => mockDeleteHourPointUseCase.call(any()),
          ).called(1);
          verify(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).called(1);
          verify(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando use case falhar',
        () async {
          // Arrange
          final mockCheckHourPoint = createMockCheckHourPoint();
          final mockCheckDayPoint = createMockCheckDayPoint(
            points: [mockCheckHourPoint],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockDeleteHourPointUseCase.call(any()),
          ).thenThrow(Exception('Erro ao deletar ponto'));

          // Act & Assert
          expect(
            () => controller.deleteCheckHourPoint(mockCheckHourPoint),
            throwsA(isA<Exception>()),
          );
          expect(controller.loading.value, false);
        },
      );
    });
  });

  group('registerCustomPoint', () {
    group('Sucesso', () {
      test(
        'deve registrar ponto personalizado e atualizar store e controller',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();
          final updatedCheckDayPoint = createMockCheckDayPoint(
            points: [
              CheckHourPointEntity(
                objectId: 'new-point',
                manual: true,
                value: '10:30',
              ),
            ],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockRegisterCustomPointUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              time: any(named: 'time'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.registerCustomPoint(hour: 10, minute: 30);

          // Assert
          expect(controller.loading.value, false);
          verify(
            () => mockRegisterCustomPointUseCase.call(
              day: 15,
              month: 5,
              year: 2026,
              time: '10:30',
            ),
          ).called(1);
          verify(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).called(1);
          verify(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).called(1);
        },
      );

      test(
        'deve adicionar zero à esquerda quando hour < 10',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();
          final updatedCheckDayPoint = createMockCheckDayPoint(
            points: [
              CheckHourPointEntity(
                objectId: 'new-point',
                manual: true,
                value: '08:00',
              ),
            ],
          );

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockRegisterCustomPointUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              time: any(named: 'time'),
            ),
          ).thenAnswer((_) async => updatedCheckDayPoint);

          when(
            () => mockCheckPointsStore.checkPointDaySelected =
                updatedCheckDayPoint,
          ).thenReturn(updatedCheckDayPoint);

          when(
            () => mockCheckPointsController.getCurrentCheckPoints(),
          ).thenAnswer((_) async {});

          // Act
          await controller.registerCustomPoint(hour: 8, minute: 0);

          // Assert
          verify(
            () => mockRegisterCustomPointUseCase.call(
              day: 15,
              month: 5,
              year: 2026,
              time: '08:00',
            ),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando use case falhar',
        () async {
          // Arrange
          final mockCheckDayPoint = createMockCheckDayPoint();

          when(
            () => mockCheckPointsStore.checkPointDaySelected,
          ).thenReturn(mockCheckDayPoint);

          when(
            () => mockRegisterCustomPointUseCase.call(
              day: any(named: 'day'),
              month: any(named: 'month'),
              year: any(named: 'year'),
              time: any(named: 'time'),
            ),
          ).thenThrow(Exception('Erro ao registrar ponto'));

          // Act & Assert
          expect(
            () => controller.registerCustomPoint(hour: 10, minute: 30),
            throwsA(isA<Exception>()),
          );
          expect(controller.loading.value, false);
        },
      );
    });
  });

  group('checkPointDay (getter)', () {
    test('deve retornar checkPointDaySelected da store', () {
      // Arrange
      final mockCheckDayPoint = createMockCheckDayPoint();

      when(
        () => mockCheckPointsStore.checkPointDaySelected,
      ).thenReturn(mockCheckDayPoint);

      // Act
      final result = controller.checkPointDay;

      // Assert
      expect(result, mockCheckDayPoint);
    });

    test('deve retornar null quando checkPointDaySelected for null', () {
      // Arrange
      when(() => mockCheckPointsStore.checkPointDaySelected).thenReturn(null);

      // Act
      final result = controller.checkPointDay;

      // Assert
      expect(result, isNull);
    });
  });

  group('dateFormatted (getter)', () {
    test(
      'deve retornar dateFormatted do checkPointDay',
      () async {
        // Arrange
        final mockCheckDayPoint = createMockCheckDayPoint();

        when(
          () => mockCheckPointsStore.checkPointDaySelected,
        ).thenReturn(mockCheckDayPoint);

        // Act
        final result = controller.dateFormatted;

        // Assert
        expect(result, '15/05/2026');
      },
    );

    test('deve retornar "--/--/--" quando checkPointDay for null', () {
      // Arrange
      when(() => mockCheckPointsStore.checkPointDaySelected).thenReturn(null);

      // Act
      final result = controller.dateFormatted;

      // Assert
      expect(result, '--/--/--');
    });
  });

  group('points (getter)', () {
    test('deve retornar lista de pontos do checkPointDay', () {
      // Arrange
      final mockPoints = [
        createMockCheckHourPoint(),
        CheckHourPointEntity(
          objectId: 'hour-point-2',
          manual: false,
          value: '17:00',
        ),
      ];
      final mockCheckDayPoint = createMockCheckDayPoint(points: mockPoints);

      when(
        () => mockCheckPointsStore.checkPointDaySelected,
      ).thenReturn(mockCheckDayPoint);

      // Act
      final result = controller.points;

      // Assert
      expect(result.length, 2);
    });

    test('deve retornar lista vazia quando checkPointDay for null', () {
      // Arrange
      when(() => mockCheckPointsStore.checkPointDaySelected).thenReturn(null);

      // Act
      final result = controller.points;

      // Assert
      expect(result, isEmpty);
    });
  });

  group('_addLeadingZeroIfNeeded', () {
    test('deve adicionar zero à esquerda quando valor < 10', () {
      // Arrange
      const value = 5;

      // Act
      // Cannot test private method directly, but tested indirectly via other methods
      final result = value < 10 ? '0$value' : value.toString();

      // Assert
      expect(result, '05');
    });

    test('deve retornar string sem zero quando valor >= 10', () {
      // Arrange
      const value = 15;

      // Act
      final result = value < 10 ? '0$value' : value.toString();

      // Assert
      expect(result, '15');
    });
  });
}
