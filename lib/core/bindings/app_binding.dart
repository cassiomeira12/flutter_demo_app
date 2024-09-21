import 'app_base_binding.dart';
import 'get_binding.dart';

extension AppBinding on AppBaseBinding {
  static final AppBaseBinding _binding = GetBinding.instance;

  static T get<T>() {
    return _binding.get<T>();
  }

  static T put<T>(
    T dependency, {
    bool permanent = false,
  }) {
    return _binding.put(
      dependency,
      permanent: permanent,
    );
  }

  static void lazyPut<T>(
    T Function() builder, {
    bool fenix = true,
  }) {
    return _binding.lazyPut(
      builder,
      fenix: fenix,
    );
  }

  static Future<T> putAsync<T>(
    Future<T> Function() builder, {
    bool permanent = false,
  }) {
    return _binding.putAsync(
      builder,
      permanent: permanent,
    );
  }

  static Future<bool> delete<T>({bool force = false}) {
    return _binding.delete(
      force: force,
    );
  }

  static Future<void> deleteAll({bool force = false}) {
    return _binding.deleteAll(force: force);
  }
}
