import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_method_handler.dart';

void main() {
  MockMethodHandler.ensureInitializedWithMock();

  setUpAll(() async {
    MockMethodHandler.getApplicationDocumentsDirectory();

    final database = AppBinding.put<OfflineFirstLocalDatabase<String>>(
      HiveOfflineFirstLocalDatabase<String>(),
    );

    await database.init(databaseName: 'test-db');
  });

  tearDownAll(() async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();
    await database.deleteAll();
    await database.removeOfflineData();
    await database.removeOfflineDeletedData();
    AppBinding.deleteAll();
  });

  test('should add values from remote', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final faker = Faker();

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

  test('should add new locally value', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final String value = faker.person.name();
    final int id = await database.add(value);

    final String? result = await database.get(id);
    expect(result, isNotNull);
    expect(result, value);

    final values = await database.values();

    expect(values.containsKey(id), true);
    expect(values[id], value);

    final valuesCredated = await database.offlineValues();

    expect(valuesCredated.containsKey(id), true);
    expect(valuesCredated[id], value);
  });

  test('should update an remote value', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final String key = faker.guid.guid();
    final String value = faker.person.name();
    await database.addByKey(key, value);

    var values = await database.values();
    values.removeWhere((key, value) => key is int);

    for (final item in values.entries) {
      final valueUpdate = '${item.value} updated';
      await database.update(item.key, valueUpdate);
    }

    final updatedValues = await database.offlineValues();

    for (final item in values.entries) {
      expect(updatedValues[item.key], '${item.value} updated');
    }

    values = await database.values();
    values.removeWhere((key, value) => key is int);

    for (final item in values.entries) {
      expect(updatedValues[item.key], values[item.key]);
    }
  });

  test('should update an locally value', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final String value = faker.person.name();
    await database.add(value);

    var values = await database.values();
    values.removeWhere((key, value) => key is String);

    for (final item in values.entries) {
      final valueUpdate = '${item.value} updated';
      await database.update(item.key, valueUpdate);
    }

    final valuesUpdated = await database.offlineValues();

    for (final item in values.entries) {
      expect(valuesUpdated[item.key], '${item.value} updated');
    }

    values = await database.values();
    values.removeWhere((key, value) => key is String);

    for (final item in values.entries) {
      expect(valuesUpdated[item.key], values[item.key]);
    }
  });

  test('should delete an remote value', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final String key = faker.guid.guid();
    final String value = faker.person.name();
    await database.addByKey(key, value);

    var values = await database.values();
    values.removeWhere((key, value) => key is int);

    final List<String> deletedIds = List.empty(growable: true);

    for (final item in values.entries) {
      await database.delete(item.key);
      deletedIds.add(item.key);
    }

    values = await database.values();
    values.removeWhere((key, value) => key is int);
    expect(values.isEmpty, true);

    final deletedValues = await database.offlineDeletedValues();

    for (final item in deletedIds) {
      expect(deletedValues.contains(item), true);
    }
  });

  test('should delete an locally value', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    final String value = faker.person.name();
    await database.add(value);

    var values = await database.values();
    values.removeWhere((key, value) => key is String);

    final List<int> deletedIds = List.empty(growable: true);

    for (final item in values.entries) {
      await database.delete(item.key);
      deletedIds.add(item.key);
    }

    values = await database.values();
    values.removeWhere((key, value) => key is String);
    expect(values.isEmpty, true);
  });

  test('should upload all new offline data and remove them', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    var values = await database.values();
    values.removeWhere((key, value) => key is String);

    final List<int> idToUpload = List.empty(growable: true);

    for (final item in values.entries) {
      expect(item.key is int, true);
      idToUpload.add(item.key);
    }

    await database.removeOfflineData(idToUpload);

    values = await database.values();
    values.removeWhere((key, value) => key is String);

    expect(values.isEmpty, true);
  });

  test('should upload all updated offline data and remove them', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    var values = await database.values();
    values.removeWhere((key, value) => key is int);

    final List<String> idToUpload = List.empty(growable: true);

    for (final item in values.entries) {
      expect(item.key is String, true);
      idToUpload.add(item.key);
    }

    await database.removeOfflineData(idToUpload);

    values = await database.values();
    values.removeWhere((key, value) => key is int);

    expect(values.isEmpty, true);
  });

  test('should upload all deleted offline data and remove them', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    var deleteValues = await database.offlineDeletedValues();

    final List<String> idToDelete = List.empty(growable: true);

    for (final item in deleteValues) {
      idToDelete.add(item);
    }

    await database.removeOfflineDeletedData(idToDelete);

    deleteValues = await database.offlineDeletedValues();

    expect(deleteValues.isEmpty, true);
  });

  test('should delete all values', () async {
    final OfflineFirstLocalDatabase<String> database = AppBinding.find();

    await database.deleteAll();
    await database.removeOfflineData();
    await database.removeOfflineDeletedData();

    final values = await database.values();
    final offlineValues = await database.offlineValues();
    final offlineDeletedValues = await database.offlineDeletedValues();

    expect(values.isEmpty, true);
    expect(offlineValues.isEmpty, true);
    expect(offlineDeletedValues.isEmpty, true);
  });
}
