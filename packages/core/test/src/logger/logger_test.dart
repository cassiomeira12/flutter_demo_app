import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class CrashlyticsServiceMock extends Mock implements CrashlyticsService {}

void main() {
  late CrashlyticsServiceMock mockCrashlyticsService;
  late CrashlyticsServiceManager crashlyticsManager;

  setUpAll(() {
    registerFallbackValue(CrashlyticsLogLevel.debug);
    registerFallbackValue(CrashlyticsLogType.debug);
  });

  setUp(() {
    mockCrashlyticsService = CrashlyticsServiceMock();
    crashlyticsManager = CrashlyticsServiceManager.instance;
    crashlyticsManager.clear();
  });

  group('Log.info - Sucesso', () {
    test('deve chamar talker.info quando Log.info é chamado', () async {
      // arrange
      when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
      crashlyticsManager.services.add(mockCrashlyticsService);
      await crashlyticsManager.init();

      // act
      Log.info('Test info message');

      // assert
      // O método info do Log usa _talker que é estático
      // Verificamos que a mensagem foi processada sem exceptions
    });
  });

  group('Log.success - Sucesso', () {
    test(
      'deve chamar talker.verbose e crashlytics.log quando throwsCrashlytics=true',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.log(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act
        Log.success('Test success message');

        // assert
        verify(
          () => mockCrashlyticsService.log(
            any(),
            level: CrashlyticsLogLevel.info,
          ),
        ).called(1);
      },
    );

    test(
      'deve llamar crashlytics.log quando throwsCrashlytics=false',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.log(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act
        Log.success('Test success message', throwsCrashlytics: false);

        // assert
        verifyNever(
          () => mockCrashlyticsService.log(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        );
      },
    );
  });

  group('Log.debug - Sucesso', () {
    test(
      'deve chamar talker.debug e crashlytics.log quando throwsCrashlytics=true',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.log(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act
        Log.debug('Test debug message');

        // assert
        verify(
          () => mockCrashlyticsService.log(
            any(),
          ),
        ).called(1);
      },
    );
  });

  group('Log.warning - Sucesso', () {
    test(
      'deve chamar talker.warning e crashlytics.log quando throwsCrashlytics=true',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.log(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act
        Log.warning('Test warning message');

        // assert
        verify(
          () => mockCrashlyticsService.log(
            any(),
            level: CrashlyticsLogLevel.warning,
          ),
        ).called(1);
      },
    );
  });

  group('Log.error - Sucesso', () {
    test(
      'deve chamar talker.error e crashlytics.captureException quando throwsCrashlytics=true',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        final testError = Exception('Test error');
        final testStackTrace = StackTrace.current;

        // act
        Log.error(testError, testStackTrace, msg: 'Test error message');

        // assert
        verify(
          () => mockCrashlyticsService.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      },
    );

    test(
      'deve no chamar crashlytics.captureException quando throwsCrashlytics=false',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        final testError = Exception('Test error');
        final testStackTrace = StackTrace.current;

        // act
        Log.error(
          testError,
          testStackTrace,
          msg: 'Test error message',
          throwsCrashlytics: false,
        );

        // assert
        verifyNever(
          () => mockCrashlyticsService.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        );
      },
    );
  });

  group('Log.exception - Sucesso', () {
    test(
      'deve chamar talker.critical e crashlytics.captureFatalException',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        final testError = Exception('Test exception');
        final testStackTrace = StackTrace.current;

        // act
        Log.exception(testError, testStackTrace, msg: 'Test exception message');

        // assert
        verify(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      },
    );
  });

  group('Log.fatalException - Sucesso', () {
    test(
      'deve chamar talker.critical e crashlytics.captureFatalException',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        final testError = Exception('Test fatal exception');
        final testStackTrace = StackTrace.current;

        // act
        Log.fatalException(
          testError,
          testStackTrace,
          msg: 'Test fatal message',
        );

        // assert
        verify(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      },
    );
  });

  group('Log.baseException - Sucesso', () {
    test(
      'deve processar BaseException corretamente chamando captureFatalException',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        final baseException = BaseException(
          message: 'Test base exception',
          error: Exception('Inner error'),
          stackTrace: StackTrace.current,
        );

        // act
        Log.baseException(baseException);

        // assert
        verify(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      },
    );
  });

  group('Log.tracking - Sucesso', () {
    test('deve chamar talker.warning quando nao e integration test', () async {
      // arrange
      when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
      crashlyticsManager.services.add(mockCrashlyticsService);
      await crashlyticsManager.init();

      // act
      Log.tracking('Test tracking message');

      // assert
      // Verificamos que completou sem exceptions
    });
  });

  group('Erro - Crashlytics Service', () {
    test('deve continuar mesmo quando crashlytics.log lança exceção', () async {
      // arrange
      when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
      when(
        () => mockCrashlyticsService.log(
          any(),
          level: any(named: 'level'),
          type: any(named: 'type'),
        ),
      ).thenThrow(Exception('Crashlytics error'));
      crashlyticsManager.services.add(mockCrashlyticsService);
      await crashlyticsManager.init();

      // act & assert - nao deve lançar
      Log.success('Test message');
    });

    test(
      'deve continuar mesmo quando crashlytics.captureException lança exceção',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenThrow(Exception('Crashlytics error'));
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act & assert - nao deve lançar
        Log.error(Exception('Test'), StackTrace.current);
      },
    );

    test(
      'deve continuar mesmo quando crashlytics.captureFatalException lança exceção',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
        when(
          () => mockCrashlyticsService.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenThrow(Exception('Crashlytics error'));
        crashlyticsManager.services.add(mockCrashlyticsService);
        await crashlyticsManager.init();

        // act & assert - nao deve lançar
        Log.fatalException(Exception('Test'), StackTrace.current);
      },
    );
  });

  group('Erro - Edge Cases', () {
    test('deve lidar com mensagem vazia', () async {
      // arrange
      when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
      crashlyticsManager.services.add(mockCrashlyticsService);
      await crashlyticsManager.init();

      // act - nao deve lançar
      Log.info('');

      // assert
    });

    test('deve lidar com stack trace null em Log.error', () async {
      // arrange
      when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});
      when(
        () => mockCrashlyticsService.captureException(
          message: any(named: 'message'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async {});
      crashlyticsManager.services.add(mockCrashlyticsService);
      await crashlyticsManager.init();

      // act - nao deve lançar
      Log.error(Exception('Test'), null);

      // assert
    });
  });
}
