import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BaseRepositoryImpl<T extends BaseEntity> implements BaseRepository<T> {
  final String _databaseName;
  final BaseCrudService<T> _service;
  final CheckInternetConnectionUseCase _checkInternetUseCase;
  final LocalStorageUseCase _localStorage;

  BaseRepositoryImpl({
    required String localDatabaseName,
    required BaseCrudService<T> service,
    required CheckInternetConnectionUseCase checkInternetUseCase,
    required LocalStorageUseCase localStorageUseCase,
  }) : _databaseName = localDatabaseName,
       _service = service,
       _checkInternetUseCase = checkInternetUseCase,
       _localStorage = localStorageUseCase {
    scheduleMicrotask(() async {
      _lastNetworkStatus = await _checkInternetUseCase.call();
      _internetConnectionSubscription = _checkInternetUseCase.internetStream
          .asBroadcastStream()
          .listen(_backgroundRemoteSyncData);
    });
  }

  String get lastFetchTimestampKey => 'last_fetch_$_databaseName';

  bool _lastNetworkStatus = false;
  StreamSubscription<bool>? _internetConnectionSubscription;

  final OfflineFirstLocalDatabase<Map<String, dynamic>> _localDatabase =
      HiveOfflineFirstLocalDatabase<Map<String, dynamic>>();

  final ValueNotifier<List<ValueNotifier<T>>> _values =
      ValueNotifier<List<ValueNotifier<T>>>(List.empty(growable: true));

  @override
  ValueNotifier<List<ValueNotifier<T>>> get valueListenable => _values;

  void _backgroundRemoteSyncData(bool isConnected, {bool autoFetch = true}) {
    _lastNetworkStatus = isConnected;
    if (isConnected) {
      Log.debug('$runtimeType background remote sync data');
      Future.wait([
        _uploadCreatedOfflineData(),
        _uploadUpdatedOfflineData(),
        _uploadDeletedOfflineData(),
      ]).whenComplete(() {
        if (autoFetch) {
          _backgroundFetchData();
        }
      });
    }
  }

  Future<void> _uploadCreatedOfflineData() async {
    final offlineValues = await _localDatabase.offlineValues();
    // remove all updated values
    offlineValues.removeWhere((key, _) => key is String);
    if (offlineValues.isEmpty) return;

    Log.info('Upload created offline data [${offlineValues.length}] length');
    final List<dynamic> removeIds = List.empty(growable: true);

    for (final entry in offlineValues.entries) {
      try {
        final resultEncrypted = await _service.create(entry.value);
        await _localDatabase.addByKey(
          resultEncrypted.objectId,
          resultEncrypted.toMap(),
        );
        final String id = entry.key.toString();
        final int index = _indexWhere(id);
        if (index >= 0) {
          _values.value[index].value = await decrypt(resultEncrypted);
        }
        removeIds.add(entry.key);
      } on BaseException catch (error) {
        if (error.throwReport) {
          Log.baseException(error);
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }

    if (removeIds.isNotEmpty) {
      Log.info('Remove created datas from offline database $removeIds');
      await _localDatabase.removeOfflineData(removeIds);
    }
  }

  Future<void> _uploadUpdatedOfflineData() async {
    final offlineValues = await _localDatabase.offlineValues();
    // remove all created values
    offlineValues.removeWhere((key, _) => key is int);
    if (offlineValues.isEmpty) return;

    Log.info('Upload updated offline data [${offlineValues.length}] length');
    final List<dynamic> removeIds = List.empty(growable: true);

    for (final entry in offlineValues.entries) {
      try {
        final resultEncrypted = await _service.update(
          entry.key,
          data: entry.value,
        );
        await _localDatabase.update(
          resultEncrypted.objectId,
          resultEncrypted.toMap(),
        );
        final String id = resultEncrypted.objectId;
        final int index = _indexWhere(id);
        if (index >= 0) {
          _values.value[index].value = await decrypt(resultEncrypted);
        }
        removeIds.add(entry.key);
      } on BaseException catch (error) {
        if (error.throwReport) {
          Log.baseException(error);
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }

    if (removeIds.isNotEmpty) {
      Log.info('Remove updated data from offline database $removeIds');
      await _localDatabase.removeOfflineData(removeIds);
    }
  }

  Future<void> _uploadDeletedOfflineData() async {
    final deleteOffline = await _localDatabase.offlineDeletedValues();
    if (deleteOffline.isEmpty) return;

    Log.info('Upload deleted offline data');
    final List<dynamic> removeIds = List.empty(growable: true);

    for (final item in deleteOffline) {
      try {
        await _service.delete(item);
        removeIds.add(item);
      } on BaseException catch (error) {
        if (error.throwReport) {
          Log.baseException(error);
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }

    if (removeIds.isNotEmpty) {
      Log.info('Remove deleted Ids from deleted database $removeIds');
      await _localDatabase.removeOfflineDeletedData(removeIds);
    }
  }

  Future<void> _backgroundFetchData() async {
    try {
      Log.info('Fetch latest remote data');
      final results = await _fetchLatestRemoteData();
      if (results.isNotEmpty) {
        await _listAllLocalData();
      }
    } on BaseException catch (error) {
      if (error.throwReport) {
        Log.baseException(error);
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  int _indexWhere(String objectId) {
    return _values.value.indexWhere(
      (ValueListenable<T> item) => item.value.objectId == objectId,
    );
  }

  @override
  Future<void> initLocalDatabase() async {
    await _localDatabase.init(databaseName: _databaseName);
    scheduleMicrotask(
      () => _backgroundRemoteSyncData(
        _lastNetworkStatus,
        autoFetch: false,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _internetConnectionSubscription?.cancel();
    await _localDatabase.close();
  }

  @override
  int Function(T a, T b)? get sort => null;

  @override
  Future<T> encrypt(T item) async => item;

  @override
  Future<T> decrypt(T item) async => item;

  @override
  Future<T> create(Map<String, dynamic> data) async {
    final T encryptedData = await encrypt(_service.parseMap(data));
    final updatedData = {
      ...encryptedData.toMap(),
      'createdAt': DateTime.now().toUtc().toString(),
      'updatedAt': DateTime.now().toUtc().toString(),
    };
    updatedData.remove('objectId');
    Log.info('Create \n[$updatedData]');
    final id = await _localDatabase.add(updatedData);
    updatedData['objectId'] = id.toString();
    final resultDecrypted = await decrypt(_service.parseMap(updatedData));
    _values.value.add(ValueNotifier<T>(resultDecrypted));
    if (sort != null) {
      _values.value.sort((a, b) => sort!(a.value, b.value));
    }
    _values.value = _values.value.toList();
    if (_lastNetworkStatus) _uploadCreatedOfflineData();
    return resultDecrypted;
  }

  @override
  Future<T> read(String objectId) {
    try {
      //
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    }
    throw UnimplementedError();
  }

  @override
  Future<T> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) async {
    final T encryptedData = await encrypt(_service.parseMap(data));
    final updatedData = {
      ...encryptedData.toMap(),
      'updatedAt': DateTime.now().toUtc().toString(),
    };
    Log.info('Update [$objectId]');
    await _localDatabase.update(objectId, updatedData);
    final resultDecrypted = await decrypt(_service.parseMap(updatedData));
    final index = _indexWhere(objectId);
    if (index >= 0) {
      _values.value[index].value = resultDecrypted;
    }
    if (sort != null) {
      _values.value.sort((a, b) => sort!(a.value, b.value));
    }
    if (_lastNetworkStatus) _uploadUpdatedOfflineData();
    return resultDecrypted;
  }

  @override
  Future<void> delete(String objectId) async {
    Log.info('Delete [$objectId]');
    await _localDatabase.delete(objectId);
    _values.value.removeWhere((item) => item.value.objectId == objectId);
    _values.value = _values.value.toList();
    if (_lastNetworkStatus) _uploadDeletedOfflineData();
  }

  @override
  Future<void> deleteLocalDatabase() async {
    try {
      Log.info('Delete all database');
      await _localDatabase.deleteAll();
      await _localDatabase.removeOfflineData();
      await _localDatabase.removeOfflineDeletedData();
      await _localStorage.delete(lastFetchTimestampKey);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace, msg: '$runtimeType deleteLocalDatabase');
    }
  }

  @override
  Future<void> fetch() async {
    try {
      Log.info('Fetch all local data');
      await _listAllLocalData();
      if (_values.value.isEmpty) {
        Log.info('Download remote data');
        await _fetchLatestRemoteData();
        await _listAllLocalData();
      } else {
        Log.info('Background download remote data');
        _backgroundFetchData();
      }
    } on BaseException catch (error) {
      if (error.throwReport) {
        Log.baseException(error);
        rethrow;
      }
    }
  }

  Future<void> _listAllLocalData() async {
    _values.value.clear();
    final values = await _localDatabase.values();
    final List<ValueNotifier<T>> list = List.empty(growable: true);
    for (final entry in values.entries) {
      final json = entry.value;
      json['objectId'] = json['objectId'] ?? entry.key.toString();
      final resultDecrypted = await decrypt(_service.parseMap(json));
      list.add(ValueNotifier<T>(resultDecrypted));
    }
    if (sort != null) {
      list.sort((a, b) => sort!(a.value, b.value));
    }
    _values.value = list;
  }

  Future<List<T>> _fetchLatestRemoteData() async {
    final lastFetch = await _localStorage.get<String>(lastFetchTimestampKey);
    final lastFetchTimestamp = DateTime.tryParse(lastFetch ?? '');

    final List<T> resultsEncrypted = await _fetchRemote(
      moreRecentThan: lastFetchTimestamp?.toUtc().toString(),
    );

    for (final item in resultsEncrypted) {
      await _localDatabase.addByKey(item.objectId, item.toMap());
    }

    _localStorage.set(lastFetchTimestampKey, DateTime.timestamp().toString());

    return resultsEncrypted;
  }

  Future<List<T>> _fetchRemote({
    String? moreRecentThan,
  }) async {
    final String? whereQuery = moreRecentThan == null
        ? null
        : '{"updatedAt":{"\$gt":{"__type":"Date","iso":"$moreRecentThan"}}}';

    const int fetchLimit = 100;
    final List<T> results = List.empty(growable: true);
    for (int skip = 0; ; skip += fetchLimit) {
      final result = await _service.list(
        limit: fetchLimit,
        skip: skip,
        where: whereQuery,
      );
      results.addAll(result);
      if (result.length < fetchLimit) break;
    }
    return results;
  }
}
