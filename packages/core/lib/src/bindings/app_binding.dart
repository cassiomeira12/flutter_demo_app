import 'package:core/src/bindings/app_base_binding.dart';
import 'package:core/src/bindings/get_binding.dart';
import 'package:dependency/dependency.dart';

extension AppBinding on AppBaseBinding {
  static final AppBaseBinding _binding = GetBinding.instance;

  static bool hasInstance<T extends Object>({String? tag}) {
    return _binding.hasInstance<T>(tag: tag);
  }

  static T find<T extends Object>({String? tag}) {
    return _binding.find<T>(tag: tag);
  }

  static T put<T extends Object>(
    T dependency, {
    String? tag,
    bool permanent = false,
  }) {
    return _binding.put<T>(dependency, tag: tag, permanent: permanent);
  }

  static void create<T extends Object>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return _binding.create<T>(builder, tag: tag, permanent: permanent);
  }

  static void lazyPut<T extends Object>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  }) {
    return _binding.lazyPut<T>(builder, tag: tag, fenix: fenix);
  }

  static Future<T> putAsync<T extends Object>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return _binding.putAsync<T>(builder, tag: tag, permanent: permanent);
  }

  static Future<bool> delete<T extends Object>({
    String? tag,
    bool force = false,
  }) {
    return _binding.delete<T>(tag: tag, force: force);
  }

  static Future<void> replace<T extends Object>(T dependency, {String? tag}) {
    return _binding.replace<T>(dependency, tag: tag);
  }

  static Future<void> deleteAll({bool force = false}) {
    return _binding.deleteAll(force: force);
  }

  static void reset() {
    return _binding.reset();
  }

  @visibleForTesting
  static void testMode(bool isTest) {
    return _binding.testMode(isTest);
  }
}
