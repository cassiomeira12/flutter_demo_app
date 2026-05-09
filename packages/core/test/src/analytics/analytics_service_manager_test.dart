import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class AnalyticsServiceMock extends Mock implements AnalyticsService {}

void main() {
  late AnalyticsServiceMock mockAnalyticsService;
  late AnalyticsServiceManager subject;

  setUpAll(() {
    // registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockAnalyticsService = AnalyticsServiceMock();
    subject = AnalyticsServiceManager.instance;
    subject.services.clear();
  });

  group('init - Sucesso', () {
    test(
      'deve inicializar serviços corretamente quando há serviços disponíveis',
      () async {
        // arrange
        when(() => mockAnalyticsService.init()).thenAnswer((_) async {});

        subject.services.add(mockAnalyticsService);

        // act
        await subject.init();

        // assert
        verify(() => mockAnalyticsService.init()).called(1);
      },
    );

    test(
      'deve adicionar fallback quando não há serviços e não está em release mode',
      () async {
        // arrange - não adiciona serviços

        // act
        await subject.init();

        // assert - deve ter pelo menos o fallback (Faker)
        // Podemos verificar indiretamente chamando logEvent que deve funcionar
        await subject.logEvent('test_event');
      },
    );

    test(
      'deve adicionar fallback quando há serviços mas nenhum inicializa com sucesso',
      () async {
        // arrange
        when(() => mockAnalyticsService.init()).thenThrow(Exception('Erro'));

        subject.services.add(mockAnalyticsService);

        // act
        await subject.init();

        // assert - deve ter o fallback pois os serviços falharam
        // Verificamos que logEvent ainda funciona com o fallback
        await subject.logEvent('test_event');
      },
    );

    test(
      'deve remover serviços da lista após inicialização bem-sucedida',
      () async {
        // arrange
        when(() => mockAnalyticsService.init()).thenAnswer((_) async {});

        subject.services.add(mockAnalyticsService);

        // act
        await subject.init();

        // assert
        expect(subject.services.isEmpty, true);
      },
    );

    test('deve inicializar múltiplos serviços corretamente', () async {
      // arrange
      final mockService1 = AnalyticsServiceMock();
      final mockService2 = AnalyticsServiceMock();

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
      final mockService1 = AnalyticsServiceMock();
      final mockService2 = AnalyticsServiceMock();

      when(() => mockService1.init()).thenThrow(Exception('Erro no serviço 1'));
      when(() => mockService2.init()).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);

      // act
      await subject.init();

      // assert - o serviço 2 deve ter sido inicializado
      verify(() => mockService2.init()).called(1);
    });

    test(
      'deve remover apenas serviços inicializados com sucesso da lista',
      () async {
        // arrange
        final mockService1 = AnalyticsServiceMock();
        final mockService2 = AnalyticsServiceMock();

        when(
          () => mockService1.init(),
        ).thenThrow(Exception('Erro no serviço 1'));
        when(() => mockService2.init()).thenAnswer((_) async {});

        subject.services.add(mockService1);
        subject.services.add(mockService2);

        // act
        await subject.init();

        // assert - apenas o serviço 2 (que inicializou com sucesso) deve ser removido
        // O serviço 1 que falhou permanece na lista
        expect(subject.services.length, 1);
        expect(subject.services.contains(mockService1), true);
      },
    );
  });

  group('logEvent', () {
    test('deve chamar logEvent em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = AnalyticsServiceMock();
      final mockService2 = AnalyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () =>
            mockService1.logEvent(any(), parameters: any(named: 'parameters')),
      ).thenAnswer((_) async {});
      when(
        () =>
            mockService2.logEvent(any(), parameters: any(named: 'parameters')),
      ).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);
      await subject.init();

      // act
      await subject.logEvent('test_event', parameters: {'key': 'value'});

      // assert
      verify(
        () => mockService1.logEvent('test_event', parameters: {'key': 'value'}),
      ).called(1);
      verify(
        () => mockService2.logEvent('test_event', parameters: {'key': 'value'}),
      ).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        await subject.logEvent('test_event', parameters: {'key': 'value'});
      },
    );

    test('deve continuar se um serviço lançar exceção no logEvent', () async {
      // arrange
      final mockService1 = AnalyticsServiceMock();
      final mockService2 = AnalyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () =>
            mockService1.logEvent(any(), parameters: any(named: 'parameters')),
      ).thenThrow(Exception('Erro no logEvent'));
      when(
        () =>
            mockService2.logEvent(any(), parameters: any(named: 'parameters')),
      ).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);
      await subject.init();

      // act & assert - não deve lançar exceção
      await subject.logEvent('test_event', parameters: {'key': 'value'});

      // assert - o serviço 2 ainda deve ser chamado
      verify(
        () => mockService2.logEvent('test_event', parameters: {'key': 'value'}),
      ).called(1);
    });
  });

  group('setUserId', () {
    test('deve chamar setUserId em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = AnalyticsServiceMock();

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
      final mockService1 = AnalyticsServiceMock();

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
      final mockService1 = AnalyticsServiceMock();
      final mockService2 = AnalyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () => mockService1.setUserId(any()),
      ).thenThrow(Exception('Erro no setUserId'));
      when(() => mockService2.setUserId(any())).thenAnswer((_) async {});

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
    test(
      'deve chamar setUserProperty em todos os serviços inicializados',
      () async {
        // arrange
        final mockService1 = AnalyticsServiceMock();

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
        final mockService1 = AnalyticsServiceMock();
        final mockService2 = AnalyticsServiceMock();

        when(() => mockService1.init()).thenAnswer((_) async {});
        when(() => mockService2.init()).thenAnswer((_) async {});
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

        // assert - o serviço 2 ainda deve ser chamado
        verify(
          () => mockService2.setUserProperty(
            name: 'age',
            property: {'value': 25},
          ),
        ).called(1);
      },
    );
  });

  group('sendAllUninitializedEvents', () {
    // Os testes de fallback events são difíceis de testar isoladamente
    // pois envolvem o mixin FallbackEventsMixin que usa o singleton
    // O comportamento pode ser verificado através dos testes de integração
    test('deve funcionar após init com serviços', () async {
      // arrange
      final mockService1 = AnalyticsServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () =>
            mockService1.logEvent(any(), parameters: any(named: 'parameters')),
      ).thenAnswer((_) async {});

      subject.services.add(mockService1);
      await subject.init();

      // act - deve funcionar normalmente após init
      await subject.logEvent('test_event', parameters: {'key': 'value'});

      // assert
      verify(
        () => mockService1.logEvent('test_event', parameters: {'key': 'value'}),
      ).called(1);
    });
  });
}
