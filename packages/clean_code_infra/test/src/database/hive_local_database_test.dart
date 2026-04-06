import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_method_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    MockMethodHandler.getApplicationDocumentsDirectory();

    final database = AppBinding.put<LocalDatabase<String>>(
      HiveLocalDatabase<String>(),
    );

    await database.init(databaseName: 'test-string-db');
  });

  tearDownAll(() async {
    final LocalDatabase<String> database = AppBinding.find();
    await database.deleteAll();
    await database.close();
    AppBinding.delete<LocalDatabase<String>>();
  });

  test('should add new value', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final Map<String, String> generatedData = {};

    for (int index = 0; index < 5; index++) {
      final String key = faker.guid.guid();
      final String value = faker.person.name();
      generatedData[key] = value;
      await database.addByKey(key, value);
    }

    final values = await database.values();

    for (final entry in generatedData.entries) {
      expect(values[entry.key], isNotNull);
      expect(values[entry.key], entry.value);
    }
  });

  test('should add new value by key', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final String value = faker.person.name();
    final int id = await database.add(value);

    final String? result = await database.get(id);
    expect(result, isNotNull);
    expect(result, value);

    final values = await database.values();

    expect(values.containsKey(id), true);
    expect(values[id], value);

    final valuesCredated = await database.values();

    expect(valuesCredated.containsKey(id), true);
    expect(valuesCredated[id], value);
  });

  test('should get a stored value', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final values = await database.values();

    for (final item in values.entries) {
      final value = await database.get(item.key);
      expect(value, isNotNull);
    }
  });

  test('should update a stored value', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final values = await database.values();

    for (final item in values.entries) {
      await database.update(item.key, '${item.value} updated');
      final value = await database.get(item.key);
      expect(item.value != value, true);
    }
  });

  test('should list all values', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final values = await database.values();

    expect(values, isNotEmpty);
  });

  test('should delete a stored value', () async {
    final LocalDatabase<String> database = AppBinding.find();

    final values = await database.values();

    await database.delete(values.keys.first);

    final value = await database.get(values.keys.first);

    expect(value, isNull);
  });

  test('should delete all values', () async {
    final LocalDatabase<String> database = AppBinding.find();

    await database.deleteAll();

    final values = await database.values();

    expect(values, isEmpty);
  });
}
