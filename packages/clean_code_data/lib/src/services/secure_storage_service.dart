import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<T?> get<T>(String key) async {
    final String? value = await _storage.read(key: key);

    if (value == null) return null;

    if (T.toString() == 'int') {
      return int.parse(value) as T;
    }
    if (T.toString() == 'bool') {
      return (value == 'true') as T;
    }
    if (T.toString() == 'double') {
      return double.parse(value) as T;
    }
    if (T.toString() == 'String') {
      return value as T;
    }
    if (T.toString() == 'List<String>') {
      return value as T;
    }
    if (T.toString() == 'Map<String, dynamic>') {
      return jsonDecode(value) as T;
    }

    return value as T?;
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    if (value is int) {
      await _storage.write(key: key, value: value.toString());
      return true;
    }
    if (value is bool) {
      await _storage.write(key: key, value: value.toString());
      return true;
    }
    if (value is double) {
      await _storage.write(key: key, value: value.toString());
      return true;
    }
    if (value is String) {
      await _storage.write(key: key, value: value.toString());
      return true;
    }
    if (value is List<String>) {
      await _storage.write(key: key, value: value.toString());
      return true;
    }
    if (value is Map) {
      await _storage.write(key: key, value: jsonEncode(value));
      return true;
    }

    throw Exception('${value.runtimeType} is not a Type acceptable');
  }

  @override
  Future<bool> delete(String key) async {
    await _storage.delete(key: key);
    return true;
  }

  @override
  Future<void> clearAll() async {
    return await _storage.deleteAll();
  }
}
