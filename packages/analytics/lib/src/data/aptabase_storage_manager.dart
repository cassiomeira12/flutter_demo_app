import 'package:dependency/dependency.dart';

class AptabaseStorageManager implements StorageManager {
  late final Box<String> _box;

  bool _initialized = false;

  @override
  Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _box = await Hive.openBox<String>('aptabase_events');
      _initialized = true;
    }
  }

  @override
  Future<void> deleteAllKeys(Iterable<dynamic> keys) {
    return _box.deleteAll(keys);
  }

  @override
  Future<Iterable<MapEntry<dynamic, String>>> getItems(int length) async {
    return _box.toMap().entries.take(length);
  }

  @override
  Future<void> add(String item) {
    return _box.add(item);
  }
}
