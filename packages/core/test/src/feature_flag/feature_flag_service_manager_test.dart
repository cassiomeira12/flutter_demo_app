import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class FeatureFlagServiceMock extends Mock implements FeatureFlagService {}

void main() {
  late FeatureFlagServiceMock mockFeatureFlagService;
  late FeatureFlagServiceManager subject;

  setUpAll(() {
    registerFallbackValue(RemoteFlagsEnum.updateApp);
    registerFallbackValue(
      DeviceTraits(
        brand: 'brand',
        model: 'model',
        osVersion: 'osVersion',
        localeName: 'localeName',
        platform: 'platform',
        packageName: 'packageName',
        version: 'version',
        build: 'build',
        isWeb: false,
        environment: 'environment',
        deviceId: 'deviceId',
      ),
    );
  });

  setUp(() {
    mockFeatureFlagService = FeatureFlagServiceMock();
    subject = FeatureFlagServiceManager.instance;
    // Limpar serviços usando o método clear público se disponível
    // O método clear é @visibleForTesting
    subject.clear();
  });

  group('init - Sucesso', () {
    test(
      'deve inicializar serviços corretamente quando há serviços disponíveis',
      () async {
        // arrange
        when(() => mockFeatureFlagService.init()).thenAnswer((_) async {});

        subject.services.add(mockFeatureFlagService);

        // act
        await subject.init();

        // assert
        verify(() => mockFeatureFlagService.init()).called(1);
      },
    );

    test(
      'deve adicionar fallback quando não há serviços disponíveis',
      () async {
        // arrange - não adiciona serviços

        // act
        await subject.init();

        // assert - deve ter pelo menos o fallback (Faker)
        // Podemos verificar indiretamente chamando getFlag que deve funcionar
        final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
        expect(flag, isA<RemoteFlag<bool>>());
      },
    );

    test(
      'deve adicionar fallback quando há serviços mas nenhum inicializa com sucesso',
      () async {
        // arrange
        when(() => mockFeatureFlagService.init()).thenThrow(Exception('Erro'));

        subject.services.add(mockFeatureFlagService);

        // act
        await subject.init();

        // assert - deve ter o fallback pois os serviços falharam
        final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
        expect(flag, isA<RemoteFlag<bool>>());
      },
    );

    test('deve inicializar múltiplos serviços corretamente', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final mockService2 = FeatureFlagServiceMock();

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
      final mockService1 = FeatureFlagServiceMock();
      final mockService2 = FeatureFlagServiceMock();
      final expectedFlag = RemoteFlag<bool>(isEnabled: false, value: false);

      when(() => mockService1.init()).thenThrow(Exception('Erro no serviço 1'));
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () => mockService2.getFlag<bool>(
          any(),
          reload: any(named: 'reload'),
        ),
      ).thenAnswer((_) async => expectedFlag);

      subject.services.add(mockService1);
      subject.services.add(mockService2);

      // act
      await subject.init();

      // assert - o serviço 2 deve ter sido inicializado
      verify(() => mockService2.init()).called(1);

      // deve ter fallback pois pelo menos um serviço falhou
      final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
      expect(flag, isA<RemoteFlag<bool>>());
    });

    test(
      'deve adicionar fallback quando todos os serviços falham',
      () async {
        // arrange
        final mockService1 = FeatureFlagServiceMock();
        final mockService2 = FeatureFlagServiceMock();

        when(
          () => mockService1.init(),
        ).thenThrow(Exception('Erro no serviço 1'));
        when(
          () => mockService2.init(),
        ).thenThrow(Exception('Erro no serviço 2'));

        subject.services.add(mockService1);
        subject.services.add(mockService2);

        // act
        await subject.init();

        // assert - deve ter fallback
        final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
        expect(flag, isA<RemoteFlag<bool>>());
      },
    );
  });

  group('getFlag', () {
    test('deve chamar getFlag no primeiro serviço inicializado', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final expectedFlag = RemoteFlag<bool>(isEnabled: true, value: true);

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () => mockService1.getFlag<bool>(
          any(),
          reload: any(named: 'reload'),
        ),
      ).thenAnswer((_) async => expectedFlag);

      subject.services.add(mockService1);
      await subject.init();

      // act
      final result = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);

      // assert
      expect(result, expectedFlag);
      verify(
        () => mockService1.getFlag<bool>(RemoteFlagsEnum.updateApp),
      ).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - não adiciona serviços, chama init para adicionar fallback
        await subject.init();

        // act & assert - não deve lançar exceção
        final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
        expect(flag, isA<RemoteFlag<bool>>());
      },
    );

    test('deve propagar erro quando o serviço lança exceção', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () => mockService1.getFlag<bool>(
          any(),
          reload: any(named: 'reload'),
        ),
      ).thenThrow(Exception('Erro ao obter flag'));

      subject.services.add(mockService1);
      await subject.init();

      // act & assert
      expect(
        () => subject.getFlag<bool>(RemoteFlagsEnum.updateApp),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('setTraits', () {
    test('deve chamar setTraits em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final traits = DeviceTraits(
        brand: 'Apple',
        model: 'iPhone 14',
        osVersion: '17.0',
        localeName: 'pt_BR',
        platform: 'iOS',
        packageName: 'com.example.app',
        version: '1.0.0',
        build: '1',
        isWeb: false,
        environment: 'production',
        deviceId: 'device123',
      );

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService1.setTraits(any())).thenAnswer((_) async {});

      subject.services.add(mockService1);
      await subject.init();

      // act
      await subject.setTraits(traits);

      // assert
      verify(() => mockService1.setTraits(traits)).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () async {
        // arrange - subject não tem serviços inicializados
        final traits = DeviceTraits(
          brand: 'Apple',
          model: 'iPhone 14',
          osVersion: '17.0',
          localeName: 'pt_BR',
          platform: 'iOS',
          packageName: 'com.example.app',
          version: '1.0.0',
          build: '1',
          isWeb: false,
          environment: 'production',
          deviceId: 'device123',
        );

        // act & assert - não deve lançar exceção
        await subject.setTraits(traits);
      },
    );

    test('deve continuar se um serviço lançar exceção no setTraits', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final mockService2 = FeatureFlagServiceMock();
      final traits = DeviceTraits(
        brand: 'Apple',
        model: 'iPhone 14',
        osVersion: '17.0',
        localeName: 'pt_BR',
        platform: 'iOS',
        packageName: 'com.example.app',
        version: '1.0.0',
        build: '1',
        isWeb: false,
        environment: 'production',
        deviceId: 'device123',
      );

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () => mockService1.setTraits(any()),
      ).thenThrow(Exception('Erro no setTraits'));
      when(() => mockService2.setTraits(any())).thenAnswer((_) async {});

      subject.services.add(mockService1);
      subject.services.add(mockService2);
      await subject.init();

      // act & assert - não deve lançar exceção
      await subject.setTraits(traits);

      // assert - o serviço 2 ainda deve ser chamado
      verify(() => mockService2.setTraits(traits)).called(1);
    });
  });

  group('setUserId', () {
    test('deve chamar setUserId em todos os serviços inicializados', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService1.setUserId(any())).thenReturn(null);

      subject.services.add(mockService1);
      await subject.init();

      // act
      subject.setUserId('user123');

      // assert
      verify(() => mockService1.setUserId('user123')).called(1);
    });

    test(
      'deve funcionar quando não há serviços inicializados (fallback)',
      () {
        // arrange - subject não tem serviços inicializados

        // act & assert - não deve lançar exceção
        subject.setUserId('user123');
      },
    );

    test('deve aceitar null como userId', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService1.setUserId(any())).thenReturn(null);

      subject.services.add(mockService1);
      await subject.init();

      // act
      subject.setUserId(null);

      // assert
      verify(() => mockService1.setUserId(null)).called(1);
    });

    test('deve continuar se um serviço lançar exceção no setUserId', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final mockService2 = FeatureFlagServiceMock();

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(() => mockService2.init()).thenAnswer((_) async {});
      when(
        () => mockService1.setUserId(any()),
      ).thenThrow(Exception('Erro no setUserId'));
      when(() => mockService2.setUserId(any())).thenReturn(null);

      subject.services.add(mockService1);
      subject.services.add(mockService2);
      await subject.init();

      // act & assert - não deve lançar exceção
      subject.setUserId('user123');

      // assert - o serviço 2 ainda deve ser chamado
      verify(() => mockService2.setUserId('user123')).called(1);
    });
  });

  group('clear', () {
    test('deve limpar serviços e serviços inicializados', () async {
      // arrange
      final mockService1 = FeatureFlagServiceMock();
      final expectedFlag = RemoteFlag<bool>(isEnabled: false, value: false);

      when(() => mockService1.init()).thenAnswer((_) async {});
      when(
        () => mockService1.getFlag<bool>(
          any(),
          reload: any(named: 'reload'),
        ),
      ).thenAnswer((_) async => expectedFlag);

      subject.services.add(mockService1);
      await subject.init();

      // act
      subject.clear();

      // assert
      expect(subject.services.isEmpty, true);
      // Após clear, não há mais serviços inicializados
      // Chamando init novamente para verificar que pode ser reconfigurado
      subject.services.add(mockService1);
      await subject.init();

      // getFlag deve funcionar com o serviço readicionado
      final flag = await subject.getFlag<bool>(RemoteFlagsEnum.updateApp);
      expect(flag, isA<RemoteFlag<bool>>());
    });
  });
}
