import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_controller.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_store.dart';
import 'package:flutter_test/flutter_test.dart';

// Mocks
class MockGetCurrentPointsUseCase extends Mock
    implements GetCurrentPointsUseCase {}

class MockRegisterPointUseCase extends Mock implements RegisterPointUseCase {}

class MockGetTotalHoursAppUseCase extends Mock
    implements GetTotalHoursAppUseCase {}

class MockCheckPointsStore extends Mock implements CheckPointsStore {}

void main() {
  late MockGetCurrentPointsUseCase mockGetCurrentPointsUseCase;
  late MockRegisterPointUseCase mockRegisterPointUseCase;
  late MockGetTotalHoursAppUseCase mockGetTotalHoursAppUseCase;
  late MockCheckPointsStore mockCheckPointsStore;
  late CheckPointsController controller;

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
  });

  setUp(() {
    mockGetCurrentPointsUseCase = MockGetCurrentPointsUseCase();
    mockRegisterPointUseCase = MockRegisterPointUseCase();
    mockGetTotalHoursAppUseCase = MockGetTotalHoursAppUseCase();
    mockCheckPointsStore = MockCheckPointsStore();

    controller = CheckPointsController(
      getCurrentPointsUseCase: mockGetCurrentPointsUseCase,
      registerPointUseCase: mockRegisterPointUseCase,
      getTotalHoursUseCase: mockGetTotalHoursAppUseCase,
      checkPointsStore: mockCheckPointsStore,
    );
  });

  tearDown(() {
    controller.onClose();
  });

  CheckDayPointEntity createMockCheckDayPoint({bool today = false}) {
    return CheckDayPointEntity(
      day: 15,
      month: 5,
      year: 2026,
      today: today,
      isWeekend: false,
      isAllowance: false,
      isHoliday: false,
      isDayOff: false,
      dateFormatted: '15/05/2026',
      totalFormatted: '08:00',
      points: [],
      hasInconsistency: false,
      info: null,
      objectId: 'mock-object-id',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  group('getCurrentCheckPoints', () {
    group('Sucesso', () {
      test(
        'deve retornar lista de pontos e atualizar o total de horas',
        () async {
          // Arrange
          final mockCheckPoints = [
            createMockCheckDayPoint(today: true),
            createMockCheckDayPoint(),
          ];
          const mockTotalHours = '08:30';

          when(
            () => mockGetCurrentPointsUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenAnswer((_) async => mockCheckPoints);

          when(
            () => mockGetTotalHoursAppUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenAnswer((_) async => mockTotalHours);

          // Act
          await controller.getCurrentCheckPoints();

          // Assert
          expect(controller.checkPoints.length, 2);
          expect(controller.totalHours.value, '08:30');
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, '');

          verify(
            () => mockGetCurrentPointsUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).called(1);

          verify(
            () => mockGetTotalHoursAppUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).called(1);
        },
      );

      test('deve calcular totalBudget corretamente', () async {
        // Arrange
        final mockCheckPoints = [createMockCheckDayPoint()];
        const mockTotalHours = '10:30'; // 10 horas e 30 minutos

        when(
          () => mockGetCurrentPointsUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockCheckPoints);

        when(
          () => mockGetTotalHoursAppUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockTotalHours);

        // Act
        await controller.getCurrentCheckPoints();

        // Assert
        // 10h * 80.10 + (80.10/60) * 30 = 801 + 40.05 = 841.05
        expect(controller.totalBudget.value, closeTo(841.05, 0.01));
      });
    });

    group('Erro', () {
      test(
        'deve definir mensagem de erro quando GetCurrentPointsUseCase falhar',
        () async {
          // Arrange
          when(
            () => mockGetCurrentPointsUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenThrow(Exception('Erro ao carregar pontos'));

          when(
            () => mockGetTotalHoursAppUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenAnswer((_) async => '00:00');

          // Act
          await controller.getCurrentCheckPoints();

          // Assert
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );

      test(
        'deve definir mensagem de erro quando GetTotalHoursAppUseCase falhar',
        () async {
          // Arrange
          final mockCheckPoints = [createMockCheckDayPoint()];

          when(
            () => mockGetCurrentPointsUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenAnswer((_) async => mockCheckPoints);

          when(
            () => mockGetTotalHoursAppUseCase.call(
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).thenThrow(Exception('Erro ao carregar horas'));

          // Act
          await controller.getCurrentCheckPoints();

          // Assert
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );
    });
  });

  group('registerPoint', () {
    group('Sucesso', () {
      test('deve registrar ponto e atualizar lista', () async {
        // Arrange
        final mockCheckPoints = [createMockCheckDayPoint(today: true)];
        const mockTotalHours = '09:00';

        when(() => mockRegisterPointUseCase.call()).thenAnswer((_) async {});

        when(
          () => mockGetCurrentPointsUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockCheckPoints);

        when(
          () => mockGetTotalHoursAppUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockTotalHours);

        // Act
        await controller.registerPoint();

        // Assert
        expect(controller.isLoading.value, false);
        verify(() => mockRegisterPointUseCase.call()).called(1);
        verify(
          () => mockGetCurrentPointsUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).called(1);
      });
    });

    group('Erro', () {
      test(
        'deve relançar exceção quando for work_point_already_created',
        () async {
          // Arrange
          when(() => mockRegisterPointUseCase.call()).thenThrow(
            BaseException(message: 'work_point_already_created'),
          );

          // Act & Assert
          expect(
            () => controller.registerPoint(),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve definir mensagem de erro quando falhar', () async {
        // Arrange
        when(
          () => mockRegisterPointUseCase.call(),
        ).thenThrow(Exception('Erro ao registrar ponto'));

        // Act
        await controller.registerPoint();

        // Assert
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, isNotEmpty);
      });
    });
  });

  group('changeSelectedDate', () {
    test(
      'deve atualizar selectedDate e chamar getCurrentCheckPoints',
      () async {
        // Arrange
        final newDate = DateTime(2026, 6, 15);
        final mockCheckPoints = [createMockCheckDayPoint()];
        const mockTotalHours = '08:00';

        when(
          () => mockGetCurrentPointsUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockCheckPoints);

        when(
          () => mockGetTotalHoursAppUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockTotalHours);

        // Act
        controller.changeSelectedDate(newDate);

        // Assert
        expect(controller.selectedDate.value.month, 6);
        expect(controller.selectedDate.value.year, 2026);
        verify(
          () => mockGetCurrentPointsUseCase.call(
            month: 6,
            year: 2026,
          ),
        ).called(1);
      },
    );
  });

  group('openCheckPoint', () {
    test('deve definir checkPointDaySelected na store', () async {
      // Arrange
      final mockCheckPoint = createMockCheckDayPoint(today: true);

      when(() => mockCheckPointsStore.checkPointDaySelected).thenReturn(null);

      // Act
      await controller.openCheckPoint(mockCheckPoint);

      // Assert
      verify(
        () => mockCheckPointsStore.checkPointDaySelected = mockCheckPoint,
      ).called(1);
    });
  });

  group('onAppForeground', () {
    test(
      'não deve alterar data quando há checkPoint de hoje com dia igual',
      () async {
        // Arrange
        final today = DateTime.now();
        final mockCheckPoints = [
          createMockCheckDayPoint(today: true).copyWith(day: today.day),
        ];
        const mockTotalHours = '08:00';

        when(
          () => mockGetCurrentPointsUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockCheckPoints);

        when(
          () => mockGetTotalHoursAppUseCase.call(
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        ).thenAnswer((_) async => mockTotalHours);

        await controller.getCurrentCheckPoints();
        final originalDate = controller.selectedDate.value;

        // Act
        controller.onAppForeground();

        // Assert - data não deve mudar se for o mesmo dia
        expect(controller.selectedDate.value, originalDate);
      },
    );
  });
}
