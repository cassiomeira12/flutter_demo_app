import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_method_handler.dart';

// -----------------------------------------------------------------------------
// Mocks (apenas para classes da camada "data")
// -----------------------------------------------------------------------------

class MockCheckInternetConnectionUseCase extends Mock
    implements CheckInternetConnectionUseCase {}

class MockOfflineFirstLocalDatabase extends Mock
    implements OfflineFirstLocalDatabase<Map<String, dynamic>> {}

/// Mock manual de [BaseCrudService] para evitar problemas com genéricos no mocktail.
class MockBaseCrudService<T> implements BaseCrudService<T> {
  T Function(Map<String, dynamic>)? _parseMapHandler;
  T Function(Map<String, dynamic>)? _createHandler;
  T Function(String, {required Map<String, dynamic> data})? _updateHandler;
  void Function(String)? _deleteHandler;
  List<T> Function({required int limit, required int skip, String? where})? _listHandler;

  void whenParseMap(T Function(Map<String, dynamic>) handler) {
    _parseMapHandler = handler;
  }

  void whenCreate(T Function(Map<String, dynamic>) handler) {
    _createHandler = handler;
  }

  void whenUpdate(T Function(String, {required Map<String, dynamic> data}) handler) {
    _updateHandler = handler;
  }

  void whenDelete(void Function(String) handler) {
    _deleteHandler = handler;
  }

  void whenList(List<T> Function({required int limit, required int skip, String? where}) handler) {
    _listHandler = handler;
  }

  @override
  T parseMap(Map<String, dynamic> map) {
    if (_parseMapHandler == null) {
      throw Exception('parseMap not stubbed');
    }
    return _parseMapHandler!(map);
  }

  @override
  Future<T> create(Map<String, dynamic> data) {
    if (_createHandler == null) {
      throw Exception('create not stubbed');
    }
    return Future.value(_createHandler!(data));
  }

  @override
  Future<void> delete(String objectId) {
    _deleteHandler?.call(objectId);
    return Future.value();
  }

  @override
  Future<List<T>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) {
    if (_listHandler == null) {
      throw Exception('list not stubbed');
    }
    return Future.value(_listHandler!(limit: limit, skip: skip, where: where));
  }

  @override
  Future<T> read(String objectId) {
    throw UnimplementedError('read not implemented in test mock');
  }

  @override
  Future<T> update(String objectId, {required Map<String, dynamic> data}) {
    if (_updateHandler == null) {
      throw Exception('update not stubbed');
    }
    return Future.value(_updateHandler!(objectId, data: data));
  }
}

/// Fake de [LocalStorageUseCase] (domain) com armazenamento em memória.
class FakeLocalStorageUseCase extends Fake implements LocalStorageUseCase {
  final _store = <String, dynamic>{};

  @override
  Future<T?> get<T>(String key) async => _store[key] as T?;

  @override
  Future<bool> set<T>(String key, T value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> delete(String key) async {
    _store.remove(key);
    return true;
  }

  @override
  Future<void> clearAll() async => _store.clear();

  @override
  Future<List<String>> getKeys() async => _store.keys.toList();
}

// -----------------------------------------------------------------------------
// Entidade de Teste
// -----------------------------------------------------------------------------

class TestEntity extends BaseEntity {
  final String name;

  TestEntity({
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
  });

  @override
  TestEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
  }) {
    return TestEntity(
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      ...super.toMap(),
    };
  }
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

TestEntity _createTestEntity({
  String? objectId,
  String name = 'Test Name',
}) {
  return TestEntity(
    objectId: objectId ?? 'test-id',
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
    name: name,
  );
}

Map<String, dynamic> _createTestMap({String name = 'Test Name'}) {
  return {'name': name};
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

void main() {
  MockMethodHandler.ensureInitializedWithMock();

  late MockBaseCrudService<TestEntity> mockService;
  late MockCheckInternetConnectionUseCase mockCheckInternetUseCase;
  late FakeLocalStorageUseCase mockLocalStorage;
  late MockOfflineFirstLocalDatabase mockLocalDatabase;
  late StreamController<bool> internetStreamController;
  late BaseRepositoryImpl<TestEntity> repository;

  setUp(() async {
    mockService = MockBaseCrudService<TestEntity>();
    mockCheckInternetUseCase = MockCheckInternetConnectionUseCase();
    mockLocalStorage = FakeLocalStorageUseCase();
    mockLocalDatabase = MockOfflineFirstLocalDatabase();
    internetStreamController = StreamController<bool>.broadcast();

    // ── Stubs padrão ────────────────────────────────────────────────────

    mockService.whenParseMap((map) {
      return TestEntity(
        objectId: map['objectId'] as String? ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'] as String)
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'] as String)
            : null,
        name: map['name'] as String? ?? '',
      );
    });

    mockService.whenCreate((map) {
      return TestEntity(
        objectId: map['objectId'] as String? ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'] as String)
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'] as String)
            : null,
        name: map['name'] as String? ?? '',
      );
    });

    mockService.whenUpdate((id, {required data}) {
      return TestEntity(
        objectId: id,
        createdAt: data['createdAt'] != null
            ? DateTime.tryParse(data['createdAt'] as String)
            : null,
        updatedAt: DateTime.now().toUtc(),
        name: data['name'] as String? ?? '',
      );
    });

    mockService.whenDelete((_) {});

    // Conectividade: online
    when(() => mockCheckInternetUseCase.call())
        .thenAnswer((_) async => true);
    when(() => mockCheckInternetUseCase.internetStream)
        .thenAnswer((_) => internetStreamController.stream);

    // Local database sem dados offline
    when(() => mockLocalDatabase.offlineValues())
        .thenAnswer((_) async => <dynamic, Map<String, dynamic>>{});
    when(() => mockLocalDatabase.offlineDeletedValues())
        .thenAnswer((_) async => <String>[]);
    when(() => mockLocalDatabase.values())
        .thenAnswer((_) async => <dynamic, Map<String, dynamic>>{});
    when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
    when(
      () => mockLocalDatabase.init(databaseName: any(named: 'databaseName')),
    ).thenAnswer((_) async {});
    when(() => mockLocalDatabase.close()).thenAnswer((_) async {});
    when(() => mockLocalDatabase.update(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockLocalDatabase.delete(any())).thenAnswer((_) async {});
    when(() => mockLocalDatabase.deleteAll()).thenAnswer((_) async {});
    when(() => mockLocalDatabase.removeOfflineData())
        .thenAnswer((_) async {});
    when(() => mockLocalDatabase.removeOfflineData(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalDatabase.removeOfflineDeletedData())
        .thenAnswer((_) async {});
    when(() => mockLocalDatabase.removeOfflineDeletedData(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalDatabase.addByKey(any(), any()))
        .thenAnswer((_) async {});

    // ── Constrói o repository ───────────────────────────────────────────
    repository = BaseRepositoryImpl<TestEntity>(
      localDatabaseName: 'test-db',
      service: mockService,
      checkInternetUseCase: mockCheckInternetUseCase,
      localStorageUseCase: mockLocalStorage,
      localDatabase: mockLocalDatabase,
    );

    // Drena a microtask agendada no construtor
    await Future.delayed(Duration.zero);
  });

  tearDown(() async {
    await internetStreamController.close();
    await repository.dispose();
  });

  // ===========================================================================
  // initLocalDatabase
  // ===========================================================================
  group('initLocalDatabase', () {
    test(
      'deve inicializar o banco local quando initLocalDatabase for chamado',
      () async {
        await repository.initLocalDatabase();

        verify(
          () => mockLocalDatabase.init(databaseName: any(named: 'databaseName')),
        ).called(1);
      },
    );

    test(
      'deve propagar exceção quando localDatabase.init falha',
      () async {
        when(
          () => mockLocalDatabase.init(databaseName: any(named: 'databaseName')),
        ).thenThrow(Exception('Falha ao inicializar banco'));

        await expectLater(
          repository.initLocalDatabase(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  // ===========================================================================
  // create
  // ===========================================================================
  group('create', () {
    test('deve criar registro local e adicionar ao valueListenable', () async {
      final data = _createTestMap();

      when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 42);

      final result = await repository.create(data);

      expect(result, isA<TestEntity>());
      expect(result.name, 'Test Name');
      expect(result.objectId, '42');
      verify(() => mockLocalDatabase.add(any())).called(1);
      expect(repository.valueListenable.value.length, 1);
      expect(repository.valueListenable.value.first.value.name, 'Test Name');
    });

    test(
      'deve adicionar createdAt e updatedAt ao criar registro',
      () async {
        final data = _createTestMap();

        await repository.create(data);

        final captured =
            verify(() => mockLocalDatabase.add(captureAny())).captured.first
                as Map<String, dynamic>;
        expect(captured, containsPair('createdAt', isA<String>()));
        expect(captured, containsPair('updatedAt', isA<String>()));
      },
    );

    test(
      'deve chamar uploadCreatedOfflineData quando online',
      () async {
        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);

        await repository.create(data);

        verify(() => mockLocalDatabase.offlineValues()).called(1);
      },
    );

    test(
      'não deve chamar uploadCreatedOfflineData quando offline',
      () async {
        when(() => mockCheckInternetUseCase.call())
            .thenAnswer((_) async => false);

        // Reconstrói com conectividade offline
        await repository.dispose();
        repository = BaseRepositoryImpl<TestEntity>(
          localDatabaseName: 'test-db',
          service: mockService,
          checkInternetUseCase: mockCheckInternetUseCase,
          localStorageUseCase: mockLocalStorage,
          localDatabase: mockLocalDatabase,
        );
        await Future.delayed(Duration.zero);

        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);

        await repository.create(data);

        verifyNever(() => mockLocalDatabase.offlineValues());
      },
    );

    test(
      'deve ordenar registros quando sort é definido',
      () async {
        final sortedRepository = BaseRepositoryImpl<TestEntity>(
          localDatabaseName: 'test-db',
          service: mockService,
          checkInternetUseCase: mockCheckInternetUseCase,
          localStorageUseCase: mockLocalStorage,
          localDatabase: mockLocalDatabase,
        );

        final data = _createTestMap(name: 'B');
        await sortedRepository.create(data);

        final dataA = _createTestMap(name: 'A');
        await sortedRepository.create(dataA);

        expect(sortedRepository.valueListenable.value.length, 2);
      },
    );
  });

  // ===========================================================================
  // update
  // ===========================================================================
  group('update', () {
    test('deve atualizar registro local quando chamado', () async {
      final data = _createTestMap();
      when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
      final created = await repository.create(data);

      final updatedData = _createTestMap(name: 'Updated Name');
      await repository.update(created.objectId, data: updatedData);

      verify(() => mockLocalDatabase.update(any(), any())).called(1);

      expect(
        repository.valueListenable.value.first.value.name,
        'Updated Name',
      );
    });

    test(
      'deve chamar uploadUpdatedOfflineData quando online',
      () async {
        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
        final created = await repository.create(data);

        final updatedData = _createTestMap(name: 'Updated');
        await repository.update(created.objectId, data: updatedData);

        // create() + update() chamam offlineValues() 2 vezes
        verify(() => mockLocalDatabase.offlineValues()).called(2);
      },
    );

    test(
      'não deve chamar uploadUpdatedOfflineData quando offline',
      () async {
        when(() => mockCheckInternetUseCase.call())
            .thenAnswer((_) async => false);

        await repository.dispose();
        repository = BaseRepositoryImpl<TestEntity>(
          localDatabaseName: 'test-db',
          service: mockService,
          checkInternetUseCase: mockCheckInternetUseCase,
          localStorageUseCase: mockLocalStorage,
          localDatabase: mockLocalDatabase,
        );
        await Future.delayed(Duration.zero);

        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
        final created = await repository.create(data);

        final updatedData = _createTestMap(name: 'Updated');
        await repository.update(created.objectId, data: updatedData);

        expect(repository.valueListenable.value, isNotEmpty);
      },
    );
  });

  // ===========================================================================
  // delete
  // ===========================================================================
  group('delete', () {
    test('deve deletar registro local e remover do valueListenable', () async {
      final data = _createTestMap();
      when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
      final created = await repository.create(data);

      expect(repository.valueListenable.value.length, 1);

      await repository.delete(created.objectId);

      verify(() => mockLocalDatabase.delete(created.objectId)).called(1);
      expect(repository.valueListenable.value.length, 0);
    });

    test(
      'deve chamar uploadDeletedOfflineData quando online',
      () async {
        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 1);
        final created = await repository.create(data);

        await repository.delete(created.objectId);

        verify(() => mockLocalDatabase.offlineDeletedValues()).called(1);
      },
    );
  });

  // ===========================================================================
  // deleteLocalDatabase
  // ===========================================================================
  group('deleteLocalDatabase', () {
    test('deve limpar dados do banco local quando chamado', () async {
      await repository.deleteLocalDatabase();

      verify(() => mockLocalDatabase.deleteAll()).called(1);
      verify(() => mockLocalDatabase.removeOfflineData()).called(1);
      verify(() => mockLocalDatabase.removeOfflineDeletedData()).called(1);
    });

    test(
      'não deve propagar exceção quando deleteAll falha',
      () async {
        when(() => mockLocalDatabase.deleteAll())
            .thenThrow(Exception('Erro ao deletar'));

        await expectLater(
          repository.deleteLocalDatabase(),
          completes,
        );
      },
    );
  });

  // ===========================================================================
  // fetch
  // ===========================================================================
  group('fetch', () {
    test('deve carregar dados locais quando existem registros', () async {
      final localEntity = _createTestEntity(name: 'Local Item');
      final localMap = localEntity.toMap();

      when(() => mockLocalDatabase.values())
          .thenAnswer((_) async => {1: localMap});

      await repository.fetch();

      expect(repository.valueListenable.value.length, 1);
      expect(
        repository.valueListenable.value.first.value.name,
        'Local Item',
      );
    });

    test(
      'deve baixar dados remotos quando banco local está vazio',
      () async {
        final remoteEntity = _createTestEntity(
          objectId: 'remote-1',
          name: 'Remote Item',
        );

        var listCallCount = 0;
        mockService.whenList(({required limit, required skip, where}) {
          listCallCount++;
          return [remoteEntity];
        });

        await repository.fetch();

        expect(listCallCount, 1);
      },
    );

    test(
      'não deve propagar exceção quando service.list lança '
      'BaseException com throwReport false',
      () async {
        mockService.whenList(({required limit, required skip, where}) {
          throw BaseException(
            message: 'Erro de rede',
            throwReport: false,
          );
        });

        await expectLater(repository.fetch(), completes);
      },
    );

    test(
      'deve propagar BaseException com throwReport true',
      () async {
        mockService.whenList(({required limit, required skip, where}) {
          throw BaseException(
            message: 'Erro crítico',
          );
        });

        await expectLater(
          repository.fetch(),
          throwsA(isA<BaseException>()),
        );
      },
    );
  });

  // ===========================================================================
  // dispose
  // ===========================================================================
  group('dispose', () {
    test('deve fechar o banco de dados quando dispose for chamado', () async {
      await expectLater(repository.dispose(), completes);
      verify(() => mockLocalDatabase.close()).called(1);
    });
  });

  // ===========================================================================
  // valueListenable
  // ===========================================================================
  group('valueListenable', () {
    test('deve iniciar com lista vazia', () {
      expect(repository.valueListenable.value, isEmpty);
    });

    test(
      'deve refletir alterações após operações CRUD',
      () async {
        expect(repository.valueListenable.value, isEmpty);

        final data = _createTestMap();
        when(() => mockLocalDatabase.add(any())).thenAnswer((_) async => 99);

        await repository.create(data);

        expect(repository.valueListenable.value.length, 1);
        expect(
          repository.valueListenable.value.first.value.objectId,
          '99',
        );
      },
    );
  });
}
