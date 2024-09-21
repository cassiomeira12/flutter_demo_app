import '../core.dart';
import 'app_base_binding.dart';

class GetBinding implements AppBaseBinding {
  GetBinding._();

  static final instance = GetBinding._();

  @override
  T get<T>() {
    return Get.find<T>();
  }

  @override
  T put<T>(
    T dependency, {
    bool permanent = false,
  }) {
    return Get.put<T>(
      dependency,
      permanent: permanent,
    );
  }

  @override
  void lazyPut<T>(
    T Function() builder, {
    bool fenix = true,
  }) {
    Get.lazyPut<T>(
      builder,
      fenix: fenix,
    );
  }

  @override
  Future<T> putAsync<T>(
    Future<T> Function() builder, {
    bool permanent = false,
  }) {
    return Get.putAsync(
      builder,
      permanent: permanent,
    );
  }

  @override
  Future<bool> delete<T>({bool force = false}) {
    return Get.delete<T>(
      force: force,
    );
  }

  @override
  Future<void> deleteAll({bool force = false}) {
    return Get.deleteAll(force: force);
  }
}
