import 'app_base_binding.dart';
import 'get_binding.dart';

extension AppBinding on AppBaseBinding {
  static final AppBaseBinding _binding = GetBinding.instance;

  static bool hasInstance<T>({String? tag}) {
    return _binding.hasInstance<T>(tag: tag);
  }

  static T find<T>({String? tag}) {
    return _binding.find<T>(tag: tag);
  }

  static T put<T>(T dependency, {String? tag, bool permanent = false}) {
    return _binding.put<T>(dependency, tag: tag, permanent: permanent);
  }

  static void create<T>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return _binding.create<T>(builder, tag: tag, permanent: permanent);
  }

  static void lazyPut<T>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  }) {
    return _binding.lazyPut<T>(builder, tag: tag, fenix: fenix);
  }

  static Future<T> putAsync<T>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return _binding.putAsync<T>(builder, tag: tag, permanent: permanent);
  }

  static Future<bool> delete<T>({String? tag, bool force = false}) {
    return _binding.delete<T>(tag: tag, force: force);
  }

  static Future<void> replace<T>(T dependency, {String? tag}) {
    return _binding.replace<T>(dependency, tag: tag);
  }

  static Future<void> deleteAll({bool force = false}) {
    return _binding.deleteAll(force: force);
  }
}
