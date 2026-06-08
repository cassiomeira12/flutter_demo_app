import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class SharedPreferencesStore extends CoreStorage {
  final LocalStorageUseCase _localStorage;

  SharedPreferencesStore({
    required LocalStorageUseCase localStorageUseCase,
  }) : _localStorage = localStorageUseCase;

  @override
  Future<void> init() async {}

  @override
  Future<bool> clear() async {
    final keys = await _localStorage.getKeys();
    keys.removeWhere((key) => !key.contains('remote_config_key_'));
    for (final key in keys) {
      await delete(key);
    }
    return true;
  }

  @override
  Future<bool> create(String key, String item) async {
    if (key.contains('remote_config_key_')) {
      final value = await _localStorage.get<String>(key);
      if (value == null) {
        return await _localStorage.set<String>(key, item);
      }
      return false;
    }
    final value = await _localStorage.get<String>('remote_config_key_$key');
    if (value == null) {
      return await _localStorage.set<String>('remote_config_key_$key', item);
    }
    return false;
  }

  @override
  Future<String?> read(String key) async {
    if (key.contains('remote_config_key_')) {
      return await _localStorage.get<String>(key);
    }
    return await _localStorage.get<String>('remote_config_key_$key');
  }

  @override
  Future<bool> delete(String key) async {
    if (key.contains('remote_config_key_')) {
      return await _localStorage.delete(key);
    }
    return await _localStorage.delete('remote_config_key_$key');
  }

  @override
  Future<List<String>> getAll() async {
    final items = <String>[];
    final keys = await _localStorage.getKeys();
    keys.removeWhere((key) => !key.contains('remote_config_key_'));
    for (final key in keys) {
      final String? item = await read(key);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  @override
  Future<bool> seed(List<MapEntry<String, String>>? items) async {
    final saved = await getAll();
    if (saved.isEmpty && items != null && items.isNotEmpty) {
      for (final item in items) {
        await create(item.key, item.value);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> update(String key, String item) async {
    if (key.contains('remote_config_key_')) {
      final value = await _localStorage.get<String>(key);
      if (value != null) {
        return await _localStorage.set<String>(key, item);
      }
      return false;
    }
    final value = await _localStorage.get<String>('remote_config_key_$key');
    if (value != null) {
      return await _localStorage.set<String>('remote_config_key_$key', item);
    }
    return false;
  }
}
