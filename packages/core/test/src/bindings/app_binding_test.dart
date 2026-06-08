import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

class TestDependency {
  final String value;
  TestDependency(this.value);
}

void main() {
  setUp(() {
    AppBinding.reset();
  });

  tearDown(() {
    AppBinding.reset();
  });

  group('AppBinding.hasInstance - Sucesso', () {
    test('deve retornar true quando a dependência está registrada', () {
      // arrange
      final dependency = TestDependency('test');
      AppBinding.put(dependency);

      // act
      final result = AppBinding.hasInstance<TestDependency>();

      // assert
      expect(result, true);
    });

    test('deve retornar false quando a dependência não está registrada', () {
      // act
      final result = AppBinding.hasInstance<TestDependency>();

      // assert
      expect(result, false);
    });

    test('deve retornar true com tag específico', () {
      // arrange
      final dependency = TestDependency('test');
      AppBinding.put(dependency, tag: 'myTag');

      // act
      final result = AppBinding.hasInstance<TestDependency>(tag: 'myTag');

      // assert
      expect(result, true);
    });

    test('deve retornar false com tag errado', () {
      // arrange
      final dependency = TestDependency('test');
      AppBinding.put(dependency, tag: 'myTag');

      // act
      final result = AppBinding.hasInstance<TestDependency>(tag: 'otherTag');

      // assert
      expect(result, false);
    });
  });

  group('AppBinding.find - Sucesso', () {
    test('deve retornar a dependência registrada', () {
      // arrange
      final dependency = TestDependency('test value');
      AppBinding.put(dependency);

      // act
      final result = AppBinding.find<TestDependency>();

      // assert
      expect(result.value, 'test value');
    });

    test('deve retornar a dependência com tag específico', () {
      // arrange
      final dependency = TestDependency('tagged value');
      AppBinding.put(dependency, tag: 'myTag');

      // act
      final result = AppBinding.find<TestDependency>(tag: 'myTag');

      // assert
      expect(result.value, 'tagged value');
    });
  });

  group('AppBinding.find - Erro', () {
    test('deve lançar exceção quando dependência não está registrada', () {
      // act & assert
      expect(
        () => AppBinding.find<TestDependency>(),
        throwsA(anything),
      );
    });
  });

  group('AppBinding.put - Sucesso', () {
    test('deve registrar e retornar a dependência', () {
      // arrange
      final dependency = TestDependency('put test');

      // act
      final result = AppBinding.put(dependency);

      // assert
      expect(result.value, 'put test');
      expect(AppBinding.hasInstance<TestDependency>(), true);
    });

    test('deve registrar com tag específico', () {
      // arrange
      final dependency = TestDependency('tagged');

      // act
      final result = AppBinding.put(dependency, tag: 'putTag');

      // assert
      expect(result.value, 'tagged');
      expect(AppBinding.hasInstance<TestDependency>(tag: 'putTag'), true);
    });

    test('deve registrar com permanent=true', () {
      // arrange
      final dependency = TestDependency('permanent');

      // act
      AppBinding.put(dependency, permanent: true);

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), true);
    });
  });

  group('AppBinding.create - Sucesso', () {
    test('deve criar a dependência usando builder', () {
      // act
      AppBinding.create<TestDependency>(() => TestDependency('created'));

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), true);
      final result = AppBinding.find<TestDependency>();
      expect(result.value, 'created');
    });

    test('deve criar com tag específico', () {
      // act
      AppBinding.create<TestDependency>(
        () => TestDependency('created with tag'),
        tag: 'createTag',
      );

      // assert
      expect(AppBinding.hasInstance<TestDependency>(tag: 'createTag'), true);
    });

    test('deve criar com permanent=true', () {
      // act
      AppBinding.create<TestDependency>(
        () => TestDependency('permanent create'),
        permanent: true,
      );

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), true);
    });
  });

  group('AppBinding.lazyPut - Sucesso', () {
    test('deve criar a dependência lazy usando builder', () {
      // act
      AppBinding.lazyPut<TestDependency>(() => TestDependency('lazy'));

      // assert - não cria até ser acessado
      final hasInstance = AppBinding.hasInstance<TestDependency>();
      expect(hasInstance, true);
      // O lazyPut no GetX cria sob demanda, então pode variar
      // Vamos verificar que podemos encontrar
      final result = AppBinding.find<TestDependency>();
      expect(result.value, 'lazy');
    });

    test('deve criar com tag específico', () {
      // act
      AppBinding.lazyPut<TestDependency>(
        () => TestDependency('lazy tagged'),
        tag: 'lazyTag',
      );

      // assert
      final result = AppBinding.find<TestDependency>(tag: 'lazyTag');
      expect(result.value, 'lazy tagged');
    });

    test('deve criar com fenix=true (padrão)', () {
      // act
      AppBinding.lazyPut<TestDependency>(() => TestDependency('fenix'));

      // assert
      final result = AppBinding.find<TestDependency>();
      expect(result.value, 'fenix');
    });
  });

  group('AppBinding.putAsync - Sucesso', () {
    test('deve registrar dependência assíncrona', () async {
      // act
      final result = await AppBinding.putAsync<TestDependency>(
        () => Future.value(TestDependency('async')),
      );

      // assert
      expect(result.value, 'async');
      expect(AppBinding.hasInstance<TestDependency>(), true);
    });

    test('deve registrar com tag específico', () async {
      // act
      final result = await AppBinding.putAsync<TestDependency>(
        () => Future.value(TestDependency('async tagged')),
        tag: 'asyncTag',
      );

      // assert
      expect(result.value, 'async tagged');
      expect(AppBinding.hasInstance<TestDependency>(tag: 'asyncTag'), true);
    });

    test('deve registrar com permanent=true', () async {
      // act
      await AppBinding.putAsync<TestDependency>(
        () => Future.value(TestDependency('async permanent')),
        permanent: true,
      );

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), true);
    });
  });

  group('AppBinding.putAsync - Erro', () {
    test('deve lançar exceção quando o future falha', () async {
      // act & assert
      expect(
        () => AppBinding.putAsync<TestDependency>(
          () => Future.error(Exception('Async error')),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AppBinding.delete - Sucesso', () {
    test('deve remover a dependência registrada', () async {
      // arrange
      AppBinding.put(TestDependency('to delete'));

      // act
      final result = await AppBinding.delete<TestDependency>();

      // assert
      expect(result, true);
      expect(AppBinding.hasInstance<TestDependency>(), false);
    });

    test('deve remover com tag específico', () async {
      // arrange
      AppBinding.put(TestDependency('to delete'), tag: 'deleteTag');

      // act
      final result = await AppBinding.delete<TestDependency>(tag: 'deleteTag');

      // assert
      expect(result, true);
      expect(AppBinding.hasInstance<TestDependency>(tag: 'deleteTag'), false);
    });

    test('deve retornar false quando dependência não existe', () async {
      // act
      final result = await AppBinding.delete<TestDependency>();

      // assert
      expect(result, false);
    });
  });

  group('AppBinding.replace - Sucesso', () {
    test('deve substituir a dependência existente', () async {
      // arrange
      AppBinding.put(TestDependency('old'));

      // act
      await AppBinding.replace(TestDependency('new'));

      // assert
      final result = AppBinding.find<TestDependency>();
      expect(result.value, 'new');
    });

    test('deve substituir com tag específico', () async {
      // arrange
      AppBinding.put(TestDependency('old'), tag: 'replaceTag');

      // act
      await AppBinding.replace(TestDependency('new'), tag: 'replaceTag');

      // assert
      final result = AppBinding.find<TestDependency>(tag: 'replaceTag');
      expect(result.value, 'new');
    });
  });

  group('AppBinding.deleteAll - Sucesso', () {
    test('deve remover todas as dependências', () async {
      // arrange
      AppBinding.put(TestDependency('dep1'));
      AppBinding.put(TestDependency('dep2'), tag: 'tag2');

      // act
      await AppBinding.deleteAll();

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), false);
    });

    test('deve remover todas as dependências com force=true', () async {
      // arrange
      AppBinding.put(TestDependency('dep1'), permanent: true);
      AppBinding.put(TestDependency('dep2'));

      // act
      await AppBinding.deleteAll(force: true);

      // assert
      expect(AppBinding.hasInstance<TestDependency>(), false);
    });
  });

  group('AppBinding - Cenários de Edge Case', () {
    test(
      'deve permitir sobrescrever dependência existente com replace',
      () async {
        // arrange
        AppBinding.put(TestDependency('first'));

        // act - GetX put não sobrescreve, precisa usar replace
        await AppBinding.replace(TestDependency('second'));

        // assert
        final result = AppBinding.find<TestDependency>();
        expect(result.value, 'second');
      },
    );

    test('deve permitir múltiplas dependências com tags diferentes', () {
      // arrange
      AppBinding.put(TestDependency('value1'), tag: 'tag1');
      AppBinding.put(TestDependency('value2'), tag: 'tag2');
      AppBinding.put(TestDependency('value3'));

      // assert
      expect(AppBinding.find<TestDependency>(tag: 'tag1').value, 'value1');
      expect(AppBinding.find<TestDependency>(tag: 'tag2').value, 'value2');
      expect(AppBinding.find<TestDependency>().value, 'value3');
    });

    test('deve lidar com tipos genéricos diferentes', () {
      // arrange
      const stringDep = 'string dependency';
      const intDep = 42;
      const doubleDep = 3.14;

      // act
      AppBinding.put(stringDep, tag: 'string');
      AppBinding.put(intDep, tag: 'int');
      AppBinding.put(doubleDep, tag: 'double');

      // assert
      expect(AppBinding.find<String>(tag: 'string'), 'string dependency');
      expect(AppBinding.find<int>(tag: 'int'), 42);
      expect(AppBinding.find<double>(tag: 'double'), 3.14);
    });
  });

  group('AppBinding - Erro de tipo', () {
    test('deve lançar exceção ao buscar tipo errado', () {
      // arrange
      AppBinding.put(TestDependency('test'));

      // act & assert - tentar buscar como outro tipo deve falhar
      expect(
        () => AppBinding.find<String>(),
        throwsA(anything),
      );
    });
  });
}
