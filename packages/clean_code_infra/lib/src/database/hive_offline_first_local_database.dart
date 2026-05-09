import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class HiveOfflineFirstLocalDatabase<T>
    with DatabaseParserMixin
    implements OfflineFirstLocalDatabase<T> {
  bool _initialized = false;

  final LocalDatabase<String> _mainDatabase = HiveLocalDatabase<String>();
  final LocalDatabase<String> _offlineDatabase = HiveLocalDatabase<String>();
  final LocalDatabase<String> _deletedDatabase = HiveLocalDatabase<String>();

  @override
  Future<void> init({required String databaseName}) async {
    if (!_initialized) {
      _initialized = true;
      final String offlineDatabaseName = '$databaseName-offline';
      final String deletedDatabaseName = '$databaseName-offline-delete';
      await _mainDatabase.init(databaseName: databaseName);
      await _offlineDatabase.init(databaseName: offlineDatabaseName);
      await _deletedDatabase.init(databaseName: deletedDatabaseName);
    }
  }

  @override
  Future<void> close() {
    return Future.wait([
      _mainDatabase.close(),
      _offlineDatabase.close(),
      _deletedDatabase.close(),
    ]);
  }

  @override
  Future<int> add(T value) async {
    return await _offlineDatabase.add(encodeValue<T>(value));
  }

  @override
  Future<void> addByKey(String key, T value) async {
    return await _mainDatabase.addByKey(key, encodeValue<T>(value));
  }

  @override
  Future<T?> get(dynamic key) async {
    if (key is int) {
      final String? value = await _offlineDatabase.get(key);
      if (value != null) {
        return decodeValue<T>(value);
      }
    }

    if (int.tryParse(key) != null) {
      final keyParsed = int.parse(key);
      final String? value = await _offlineDatabase.get(keyParsed);
      if (value != null) {
        return decodeValue<T>(value);
      }
    }

    String? value = await _offlineDatabase.get(key);
    value ??= await _mainDatabase.get(key);

    if (value == null) return null;

    return decodeValue<T>(value);
  }

  @override
  Future<void> update(dynamic key, T value) async {
    if (key is int) {
      final hasValue = await _offlineDatabase.get(key);
      if (hasValue != null) {
        return await _offlineDatabase.update(key, encodeValue<T>(value));
      }
    }

    if (int.tryParse(key) != null) {
      final keyParsed = int.parse(key);
      final hasValue = await _offlineDatabase.get(keyParsed);
      if (hasValue != null) {
        return await _offlineDatabase.update(keyParsed, encodeValue<T>(value));
      }
    }

    var hasValue = await _offlineDatabase.get(key);
    if (hasValue != null) {
      return await _offlineDatabase.update(key, encodeValue<T>(value));
    }

    hasValue = await _mainDatabase.get(key);
    if (hasValue != null) {
      return await _offlineDatabase.update(key, encodeValue<T>(value));
    }

    throw NotFoundException();
  }

  @override
  Future<void> delete(dynamic key) async {
    if (key is int) {
      final hasValue = await _offlineDatabase.get(key);
      if (hasValue != null) {
        return await _offlineDatabase.delete(key);
      }
    }

    if (int.tryParse(key) != null) {
      final keyParsed = int.parse(key);
      final hasValue = await _offlineDatabase.get(keyParsed);
      if (hasValue != null) {
        return await _offlineDatabase.delete(keyParsed);
      }
    }

    var hasValue = await _offlineDatabase.get(key);
    if (hasValue != null) {
      await _offlineDatabase.delete(key);
    }

    hasValue = await _mainDatabase.get(key);
    if (hasValue != null) {
      Log.info('Add [$key] in offline deleted database');
      await _deletedDatabase.addByKey(key, key);
      Log.info('Delete [$key] in offline database');
      return await _mainDatabase.delete(key);
    }
  }

  @override
  Future<void> deleteAll([Iterable<dynamic>? keys]) async {
    return await _mainDatabase.deleteAll(keys);
  }

  @override
  Future<void> removeOfflineData([Iterable<dynamic>? keys]) async {
    return await _offlineDatabase.deleteAll(keys);
  }

  @override
  Future<void> removeOfflineDeletedData([Iterable<dynamic>? keys]) async {
    return await _deletedDatabase.deleteAll(keys);
  }

  @override
  Future<Map<dynamic, T>> values() async {
    final Map<dynamic, String> values = await _mainDatabase.values();
    final parsedValues = values.map<dynamic, T>(
      (key, value) => MapEntry(key, decodeValue<T>(value)),
    );
    final offlineData = await offlineValues();
    for (final entry in offlineData.entries) {
      parsedValues[entry.key] = entry.value;
    }
    return parsedValues;
  }

  @override
  Future<Map<dynamic, T>> offlineValues() async {
    final Map<dynamic, String> values = await _offlineDatabase.values();
    return values.map<dynamic, T>(
      (key, value) => MapEntry(key, decodeValue<T>(value)),
    );
  }

  @override
  Future<List<String>> offlineDeletedValues() async {
    final Map<dynamic, String> values = await _deletedDatabase.values();
    return values.values.toList();
  }
}
