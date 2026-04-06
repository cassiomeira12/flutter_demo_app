import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_method_handler.dart';

class InternetConnectionServiceMock extends Mock
    implements InternetConnectionService {
  @override
  Future<bool> hasInternetAccess() => Future.value(true);

  @override
  void addStream(StreamController<bool> streamController) {}

  @override
  void pauseStream() {}

  @override
  void resumeStream() {}

  @override
  void dispose() {}
}

class BaseCrudServiceMock<T> extends Mock implements BaseCrudService<T> {}

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final faker = Faker();
  late BaseCrudService<TestEntity> service;

  setUpAll(() async {
    MockMethodHandler.getApplicationDocumentsDirectory();

    service = AppBinding.put<BaseCrudService<TestEntity>>(
      BaseCrudServiceMock<TestEntity>(),
    );

    when(
      () => service.parseMap(any()),
    ).thenAnswer((result) {
      final Map<String, dynamic> map = result.positionalArguments.first;
      return TestEntity(
        objectId: map['objectId'] ?? '',
        createdAt: map['createdAt'] == null
            ? null
            : DateTime.tryParse(map['createdAt']),
        updatedAt: map['updatedAt'] == null
            ? null
            : DateTime.tryParse(map['updatedAt']),
        name: map['name'],
      );
    });

    when(
      () => service.create(any()),
    ).thenAnswer((result) async {
      final Map<String, dynamic> map = result.positionalArguments.first;
      return TestEntity(
        objectId: faker.guid.guid(),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        name: map['name'],
      );
    });

    when(
      () => service.update(any(), data: any(named: 'data')),
    ).thenAnswer((result) async {
      final Map<String, dynamic> map =
          result.namedArguments[const Symbol('data')];
      return TestEntity(
        objectId: map['objectId'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.now().toUtc(),
        name: map['name'],
      );
    });

    when(
      () => service.delete(any()),
    ).thenAnswer((_) async {});

    AppBinding.put<InternetConnectionService>(InternetConnectionServiceMock());

    AppBinding.put<CheckInternetConnectionUseCase>(
      CheckInternetConnectionUseCaseImpl(
        internetConnectionService: AppBinding.find(),
      ),
    );

    AppBinding.put<LocalStorage>(HiveLocalStorage());
    AppBinding.put<LocalStorageUseCase>(
      LocalStorageUseCaseImpl(
        localStorage: AppBinding.find(),
      ),
    );

    final repository = AppBinding.put<BaseRepository<TestEntity>>(
      BaseRepositoryImpl<TestEntity>(
        localDatabaseName: 'test-db',
        service: AppBinding.find(),
        checkInternetUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
    );

    await repository.initLocalDatabase();
  });

  tearDownAll(() async {
    final repository = AppBinding.find<BaseRepository<TestEntity>>();
    await repository.deleteLocalDatabase();
    AppBinding.delete<BaseRepository<TestEntity>>();
    AppBinding.delete<LocalStorage>();
    AppBinding.delete<CheckInternetConnectionUseCase>();
    AppBinding.delete<InternetConnectionService>();
    AppBinding.delete<BaseCrudService<TestEntity>>();
  });

  test('should fetch data', () async {
    final repository = AppBinding.find<BaseRepository<TestEntity>>();

    expect(repository.valueListenable.value, isEmpty);

    final List<TestEntity> list = List.empty(growable: true);

    for (int index = 0; index < 5; index++) {
      list.add(
        TestEntity(
          objectId: faker.guid.guid(),
          createdAt: faker.date.dateTime(
            minYear: DateTime.now().year - 1,
            maxYear: DateTime.now().year,
          ),
          updatedAt: faker.date.dateTime(
            minYear: DateTime.now().year,
            maxYear: DateTime.now().year + 1,
          ),
          name: faker.person.name(),
        ),
      );
    }

    when(
      () => service.list(
        limit: any(named: 'limit'),
        order: any(named: 'order'),
        skip: any(named: 'skip'),
        where: any(named: 'where'),
      ),
    ).thenAnswer((_) async {
      return list;
    });

    await repository.fetch();

    expect(repository.valueListenable.value, isNotEmpty);
  });

  test('should create and upload new data', () async {
    final repository = AppBinding.find<BaseRepository<TestEntity>>();

    final faker = Faker();

    final Map<String, dynamic> map = {
      'name': faker.person.name(),
    };

    final TestEntity result = await repository.create(map);

    expect(result.name, map['name']);

    List<TestEntity> list = repository.valueListenable.value
        .map((item) => item.value)
        .toList();
    list.removeWhere((item) => item.objectId != result.objectId);

    expect(list.isNotEmpty, true);

    await Future.delayed(const Duration(milliseconds: 100));

    list = repository.valueListenable.value.map((item) => item.value).toList();

    for (final item in list) {
      expect(item.objectId != result.objectId, true);
    }
  });

  test('should update and upload new data', () async {
    final repository = AppBinding.find<BaseRepository<TestEntity>>();

    final faker = Faker();

    final Map<String, dynamic> map = {
      'name': faker.person.name(),
    };

    final TestEntity result = await repository.create(map);

    expect(result.name, map['name']);

    List<TestEntity> list = repository.valueListenable.value
        .map((item) => item.value)
        .toList();
    list.removeWhere((item) => item.objectId != result.objectId);

    expect(list.isNotEmpty, true);

    await Future.delayed(const Duration(milliseconds: 100));

    list = repository.valueListenable.value.map((item) => item.value).toList();

    for (final item in list) {
      expect(item.objectId != result.objectId, true);
    }

    var updatedItem = list.firstWhere((item) => item.name == result.name);

    final String updatedName = faker.person.name();

    updatedItem = updatedItem.copyWith(name: updatedName);

    updatedItem = await repository.update(
      updatedItem.objectId,
      data: updatedItem.toMap(),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    expect(updatedItem.name, updatedName);

    list = repository.valueListenable.value.map((item) => item.value).toList();
    list.removeWhere((item) => item.objectId != updatedItem.objectId);

    expect(list.length, 1);
    expect(list.first.objectId, updatedItem.objectId);
    expect(list.first.name, updatedName);
    expect(list.first.createdAt, updatedItem.createdAt);
    expect(list.first.updatedAt != updatedItem.updatedAt, true);
  });

  test('should delete and upload', () async {
    final repository = AppBinding.find<BaseRepository<TestEntity>>();

    final faker = Faker();

    final Map<String, dynamic> map = {
      'name': faker.person.name(),
    };

    final TestEntity result = await repository.create(map);

    expect(result.name, map['name']);

    List<TestEntity> list = repository.valueListenable.value
        .map((item) => item.value)
        .toList();
    list.removeWhere((item) => item.objectId != result.objectId);

    expect(list.isNotEmpty, true);

    await Future.delayed(const Duration(milliseconds: 100));

    list = repository.valueListenable.value.map((item) => item.value).toList();

    for (final item in list) {
      expect(item.objectId != result.objectId, true);
    }

    final deleteItem = list.firstWhere((item) => item.name == result.name);

    await repository.delete(deleteItem.objectId);

    await Future.delayed(const Duration(milliseconds: 100));

    list = repository.valueListenable.value.map((item) => item.value).toList();

    for (final item in list) {
      expect(item.objectId != deleteItem.objectId, true);
    }
  });
}
