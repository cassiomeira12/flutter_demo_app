import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class CrashlyticsServiceMock extends Mock implements CrashlyticsService {}

class TrackOperationMock extends Mock implements TrackOperation {}

void main() {
  late CrashlyticsServiceMock mockCrashlyticsService;
  late CrashlyticsServiceManager subject;

  setUpAll(() {
    registerFallbackValue(CrashlyticsLogLevel.debug);
    registerFallbackValue(CrashlyticsLogType.debug);
    registerFallbackValue(IpAddressLocationEntity.emptyIpAddress());
  });

  setUp(() {
    mockCrashlyticsService = CrashlyticsServiceMock();
    subject = CrashlyticsServiceManager.instance;
    subject.clear();
    // Limpar serviços inicializados acessando via reflexão ou método interno
    // O clear não é público, então precisamos testar o comportamento
  });

  group('init - Sucesso', () {
    test(
      'deve inicializar serviços corretamente quando há serviços disponíveis',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenAnswer((_) async {});

        subject.services.add(mockCrashlyticsService);

        // act
        await subject.init();

        // assert
        verify(() => mockCrashlyticsService.init()).called(1);
      },
    );

    test(
      'deve adicionar fallback quando não há serviços e não está em release mode',
      () async {
        // arrange - não adiciona serviços

        // act
        await subject.init();

        // assert - deve ter pelo menos o fallback (Faker)
        // Podemos verificar indiretamente chamando log que deve funcionar
        subject.log('test_message');
      },
    );

    test(
      'deve adicionar fallback quando há serviços mas nenhum inicializa com sucesso',
      () async {
        // arrange
        when(() => mockCrashlyticsService.init()).thenThrow(Exception('Erro'));

        subject.services.add(mockCrashlyticsService);

        // act
        await subject.init();

        // assert - deve ter o fallback pois os serviços falharam
        // Verificamos que log ainda funciona com o fallback
        subject.log('test_message');
      },
    );

    test('deve inicializar múltiplos serviços corretamente', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();
      final mockService2 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);

      // act
      await subject.init();

      // assert
      verify(() => mockService1.init()).called(1);
      verify(() => mockService2.init()).called(1);
    });
  });

  group('init - Erro', () {
    test('deve continuar mesmo quando um serviço falha durante init', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();
      final mockService2 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenThrow(Exception('Erro no serviço 1'));
      when(() => mockService2.init()).thenAnswer((_) async {});

      when(
        () => mockService2.captureException(
          message: any(named: 'message'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);

      // act
      await subject.init();

      // assert - o serviço 2 deve ter sido inicializado
      verify(() => mockService2.init()).called(1);
    });
  });

  group('log', () {
    test('deve chamar log em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () => mockService1.log(
          any(),
          level: any(named: 'level'),
          type: any(named: 'type'),
        ),
      ).thenReturn(null);

      subject.services.add(mockService1);
      await subject.init();

      // act
      subject.log('test_message', level: CrashlyticsLogLevel.error);

      // assert
      verify(
        () => mockService1.log(
          'test_message',
          level: CrashlyticsLogLevel.error,
        ),
      ).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        subject.log('test_message', level: CrashlyticsLogLevel.error);
      },
    );

    test('deve continuar se um serviço lançar exceção no log', () {
      // arrange
      final mockService1 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () => mockService1.log(
          any(),
          level: any(named: 'level'),
          type: any(named: 'type'),
        ),
      ).thenThrow(Exception('Erro no log'));

      subject.services.add(mockService1);

      // act & assert - não deve lançar exceção
      subject.log('test_message');
    });
  });

  group('logHttp', () {
    setUp(() {
      CrashlyticsServiceManager.instance.clear();
    });

    test(
      'deve chamar logHttp em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.logHttp(
            any(),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);

        subject.services.add(mockService1);
        await subject.init();

        // act
        subject.logHttp('test_message', level: CrashlyticsLogLevel.error);

        // assert
        verify(
          () => mockService1.logHttp(
            'test_message',
            level: CrashlyticsLogLevel.error,
          ),
        ).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        subject.logHttp('test_message', level: CrashlyticsLogLevel.error);
      },
    );
  });

  group('logUserInteraction', () {
    test(
      'deve chamar logUserInteraction em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.logUserInteraction(
            any(),
            parameters: any(named: 'parameters'),
            level: any(named: 'level'),
            type: any(named: 'type'),
          ),
        ).thenReturn(null);

        subject.services.add(mockService1);
        await subject.init();

        // act
        subject.logUserInteraction('test_event', parameters: {'key': 'value'});

        // assert
        verify(
          () => mockService1.logUserInteraction(
            'test_event',
            parameters: {'key': 'value'},
          ),
        ).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        subject.logUserInteraction('test_event', parameters: {'key': 'value'});
      },
    );
  });

  group('setUserId', () {
    test('deve chamar setUserId em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService1.setUserId(any())).thenAnswer((_) async {});

      subject.services.add(mockService1);
      await subject.init();

      // act
      await subject.setUserId('user123');

      // assert
      verify(() => mockService1.setUserId('user123')).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.setUserId('user123');
      },
    );

    test('deve aceitar null como userId', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService1.setUserId(any())).thenAnswer((_) async {});

      subject.services.add(mockService1);
      await subject.init();

      // act
      await subject.setUserId(null);

      // assert
      verify(() => mockService1.setUserId(null)).called(1);
    });

    test('deve continuar se um serviço lançar exceção no setUserId', () async {
      // arrange
      final mockService1 = CrashlyticsServiceMock();
      final mockService2 = CrashlyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () => mockService1.setUserId(any()),
      ).thenThrow(Exception('Erro no setUserId'));
      when(() => mockService2.setUserId(any())).thenAnswer((_) async {});
      when(
        () => mockService2.captureException(
          message: any(named: 'message'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockService1.captureException(
          message: any(named: 'message'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);
      await subject.init();

      // act & assert - não deve lançar exceção
      await subject.setUserId('user123');

      // assert - o serviço 2 ainda deve ser chamado
      verify(() => mockService2.setUserId('user123')).called(1);
    });
  });

  group('setUserProperty', () {
    setUp(() {
      CrashlyticsServiceManager.instance.clear();
    });

    test(
      'deve chamar setUserProperty em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.setUserProperty(
            name: any(named: 'name'),
            property: any(named: 'property'),
          ),
        ).thenAnswer((_) async {});

        subject.services.add(mockService1);
        await subject.init();

        // act
        await subject.setUserProperty(
          name: 'age',
          property: {'value': 25},
        );

        // assert
        verify(
          () => mockService1.setUserProperty(
            name: 'age',
            property: {'value': 25},
          ),
        ).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.setUserProperty(
          name: 'age',
          property: {'value': 25},
        );
      },
    );

    test(
      'deve continuar se um serviço lançar exceção no setUserProperty',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final mockService2 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService2.init()).thenAnswer((_) async {});

        when(
          () => mockService1.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockService2.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});

        when(
          () => mockService1.setUserProperty(
            name: any(named: 'name'),
            property: any(named: 'property'),
          ),
        ).thenThrow(Exception('Erro no setUserProperty'));
        when(
          () => mockService2.setUserProperty(
            name: any(named: 'name'),
            property: any(named: 'property'),
          ),
        ).thenAnswer((_) async {});

        subject.services.add(mockService1);
        subject.services.add(mockService2);
        await subject.init();

        // act & assert - não deve lançar exceção
        await subject.setUserProperty(
          name: 'age',
          property: {'value': 25},
        );

        // assert - o serviço 2 ainda deve ser chamado (pelo menos 1 vez)
        // Em modo debug, o fallback também é adicionado, então pode ser chamado 2 vezes
        verify(
          () => mockService2.setUserProperty(
            name: 'age',
            property: {'value': 25},
          ),
        ).called(greaterThanOrEqualTo(1));
      },
    );
  });

  group('setIpAddress', () {
    test(
      'deve chamar setIpAddress em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final ipAddress = IpAddressLocationEntity(
          country: 'Brazil',
          countryCode: 'BR',
          region: 'SP',
          regionName: 'São Paulo',
          city: 'São Paulo',
          zip: '01000',
          latitude: -23.5505,
          longitude: -46.6333,
          timezone: 'America/Sao_Paulo',
          isp: 'Internet Provider',
          org: 'Organization',
          ispOrg: 'ISP Organization',
          ip: '192.168.1.1',
        );

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService1.setIpAddress(any())).thenReturn(null);

        subject.services.add(mockService1);
        await subject.init();

        // act
        subject.setIpAddress(ipAddress);

        // assert
        verify(() => mockService1.setIpAddress(ipAddress)).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        final ipAddress = IpAddressLocationEntity(
          country: 'Brazil',
          countryCode: 'BR',
          region: 'SP',
          regionName: 'São Paulo',
          city: 'São Paulo',
          zip: '01000',
          latitude: -23.5505,
          longitude: -46.6333,
          timezone: 'America/Sao_Paulo',
          isp: 'Internet Provider',
          org: 'Organization',
          ispOrg: 'ISP Organization',
          ip: '192.168.1.1',
        );
        subject.setIpAddress(ipAddress);
      },
    );
  });

  group('captureException', () {
    test(
      'deve chamar captureException em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});

        subject.services.add(mockService1);
        await subject.init();

        // act
        await subject.captureException(
          message: 'Test message',
          error: error,
          stackTrace: stackTrace,
        );

        // assert
        verify(
          () => mockService1.captureException(
            message: 'Test message',
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.captureException(
          message: 'Test message',
          error: Exception('Test error'),
          stackTrace: StackTrace.current,
        );
      },
    );

    test(
      'deve continuar se um serviço lançar exceção no captureException',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final mockService2 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService2.init()).thenAnswer((_) async {});
        when(
          () => mockService1.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenThrow(Exception('Erro no captureException'));
        when(
          () => mockService2.captureException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});

        subject.services.add(mockService1);
        subject.services.add(mockService2);
        await subject.init();

        // act & assert - não deve lançar exceção
        await subject.captureException(
          message: 'Test message',
          error: Exception('Test error'),
          stackTrace: StackTrace.current,
        );

        // assert - o serviço 2 ainda deve ser chamado (pelo menos 1 vez)
        // Em modo debug, o fallback também é adicionado, então pode ser chamado 2 vezes
        verify(
          () => mockService2.captureException(
            message: 'Test message',
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(greaterThanOrEqualTo(1));
      },
    );
  });

  group('captureFatalException', () {
    test(
      'deve chamar captureFatalException em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final error = Exception('Fatal error');
        final stackTrace = StackTrace.current;

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.captureFatalException(
            message: any(named: 'message'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenAnswer((_) async {});

        subject.services.add(mockService1);
        await subject.init();

        // act
        await subject.captureFatalException(
          message: 'Fatal message',
          error: error,
          stackTrace: stackTrace,
        );

        // assert
        verify(
          () => mockService1.captureFatalException(
            message: 'Fatal message',
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.captureFatalException(
          message: 'Fatal message',
          error: Exception('Fatal error'),
          stackTrace: StackTrace.current,
        );
      },
    );
  });

  group('trackOperation', () {
    test(
      'deve retornar TrackOperation quando há serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();
        final mockTrackOperation = TrackOperationMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(
          () => mockService1.trackOperation(
            name: any(named: 'name'),
            description: any(named: 'description'),
            startTimestamp: any(named: 'startTimestamp'),
          ),
        ).thenReturn(mockTrackOperation);

        subject.services.add(mockService1);
        await subject.init();

        // act
        final result = subject.trackOperation(
          name: 'test_operation',
          description: 'Test description',
        );

        // assert
        expect(result, isA<TrackOperation>());
        verify(
          () => mockService1.trackOperation(
            name: 'test_operation',
            description: 'Test description',
            startTimestamp: any(named: 'startTimestamp'),
          ),
        ).called(1);
      },
    );

    test(
      'deve retornar UninitializedTrackOperation quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act
        final result = subject.trackOperation(
          name: 'test_operation',
          description: 'Test description',
        );

        // assert
        expect(result, isA<UninitializedTrackOperation>());
      },
    );
  });

  group('simulateCrash', () {
    test(
      'deve chamar simulateCrash em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService1.simulateCrash()).thenReturn(null);

        subject.services.add(mockService1);
        await subject.init();

        // act
        subject.simulateCrash();

        // assert
        verify(() => mockService1.simulateCrash()).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        subject.simulateCrash();
      },
    );
  });

  group('updateInitSettings', () {
    test(
      'deve chamar updateInitSettings em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = CrashlyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService1.updateInitSettings()).thenAnswer((_) async {});

        subject.services.add(mockService1);
        await subject.init();

        // act
        await subject.updateInitSettings();

        // assert
        verify(() => mockService1.updateInitSettings()).called(1);
      },
    );

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.updateInitSettings();
      },
    );
  });
}
