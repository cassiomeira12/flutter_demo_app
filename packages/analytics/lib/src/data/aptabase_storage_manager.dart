import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:dependency/dependency.dart';

class AptabaseStorageManager implements StorageManager {
  final _localDatabase = HiveLocalDatabase<String>();

  @override
  Future<void> init() async {
    return _localDatabase.init(databaseName: 'aptabase_events');
  }

  @override
  Future<void> add(String item) {
    return _localDatabase.add(item);
  }

  @override
  Future<void> deleteAllKeys(Iterable<dynamic> keys) {
    return _localDatabase.deleteAll(keys);
  }

  @override
  Future<Iterable<MapEntry<dynamic, String>>> getItems(int length) async {
    final list = await _localDatabase.values();
    return list.entries.take(length);
  }
}
