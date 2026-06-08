import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class HiveLocalDatabase<T>
    with DatabaseParserMixin
    implements LocalDatabase<T> {
  String? _dbName;

  bool _initialized = false;

  late final Box<String> _hiveBox;

  @override
  Future<void> init({required String databaseName}) async {
    if (!_initialized) {
      try {
        _initialized = true;
        _dbName = databaseName;
        await Hive.initFlutter();
        _hiveBox = await Hive.openBox<String>(databaseName);
        if (!Log.isIntegrationTest) {
          Log.success(
            'Local Database [$databaseName] init successful',
            throwsCrashlytics: false,
          );
        }
      } catch (error, stackTrace) {
        _throw('init', error, stackTrace);
      }
    }
  }

  @override
  Future<void> close() async {
    try {
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].close');
      }
      return await _hiveBox.close();
    } catch (error, stackTrace) {
      _throw('close', error, stackTrace);
    }
  }

  @override
  Future<int> add(T value) async {
    try {
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].add \n$value');
      }
      return await _hiveBox.add(encodeValue<T>(value));
    } catch (error, stackTrace) {
      _throw('add', error, stackTrace);
    }
  }

  @override
  Future<void> addByKey(String key, T value) async {
    try {
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].addByKey [$key] \n$value');
      }
      return await _hiveBox.put(key, encodeValue<T>(value));
    } catch (error, stackTrace) {
      _throw('addByKey', error, stackTrace);
    }
  }

  @override
  Future<T?> get(dynamic key) async {
    try {
      final String? value = _hiveBox.get(key);
      if (value == null) {
        if (!Log.isIntegrationTest) {
          Log.warning(
            '[$_dbName].get [$key] not found',
            throwsCrashlytics: false,
          );
        }
        return null;
      }
      if (!Log.isIntegrationTest) {
        Log.success('[$_dbName].get [$key]', throwsCrashlytics: false);
      }
      return decodeValue<T>(value);
    } catch (error, stackTrace) {
      _throw('get', error, stackTrace);
    }
  }

  @override
  Future<void> update(dynamic key, T value) async {
    try {
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].update [$key] \n$value');
      }
      return await _hiveBox.put(key, encodeValue<T>(value));
    } catch (error, stackTrace) {
      _throw('update', error, stackTrace);
    }
  }

  @override
  Future<void> delete(dynamic key) async {
    try {
      if (_hiveBox.get(key) == null) {
        if (!Log.isIntegrationTest) {
          Log.warning(
            '[$_dbName].delete [$key] not found',
            throwsCrashlytics: false,
          );
        }
        throw NotFoundException();
      } else {
        if (!Log.isIntegrationTest) {
          Log.success('[$_dbName].delete [$key]', throwsCrashlytics: false);
        }
        return await _hiveBox.delete(key);
      }
    } catch (error, stackTrace) {
      _throw('delete', error, stackTrace);
    }
  }

  @override
  Future<void> deleteAll([Iterable<dynamic>? keys]) async {
    try {
      if (keys == null) {
        await _hiveBox.clear();
        if (!Log.isIntegrationTest) {
          Log.info('[$_dbName].deleteAll');
        }
        return;
      }
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].deleteAll keys $keys');
      }
      return await _hiveBox.deleteAll(keys);
    } catch (error, stackTrace) {
      _throw('deleteAll', error, stackTrace);
    }
  }

  @override
  Future<Map<dynamic, T>> values() async {
    try {
      final values = _hiveBox.toMap().map<dynamic, T>((key, value) {
        return MapEntry(key, decodeValue<T>(value));
      });
      if (!Log.isIntegrationTest) {
        Log.info('[$_dbName].values [${values.length}] length');
      }
      return values;
    } catch (error, stackTrace) {
      _throw('values', error, stackTrace);
    }
  }

  Never _throw(String method, Object error, StackTrace stackTrace) {
    throw BaseException(
      message: '$runtimeType $method',
      error: error,
      stackTrace: stackTrace,
      complement: 'databaseName: $_dbName',
    );
  }
}
