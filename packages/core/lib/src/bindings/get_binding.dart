import 'package:core/src/bindings/app_base_binding.dart';
import 'package:dependency/dependency.dart';

class GetBinding implements AppBaseBinding {
  GetBinding._();

  static final instance = GetBinding._();

  @override
  bool hasInstance<T extends Object>({String? tag}) {
    return Get.isRegistered<T>(tag: tag);
  }

  @override
  T find<T extends Object>({String? tag}) {
    return Get.find<T>(tag: tag);
  }

  @override
  T put<T extends Object>(T dependency, {String? tag, bool permanent = false}) {
    return Get.put<T>(dependency, tag: tag, permanent: permanent);
  }

  @override
  void create<T extends Object>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return Get.create<T>(builder, tag: tag, permanent: permanent);
  }

  @override
  void lazyPut<T extends Object>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  }) {
    return Get.lazyPut<T>(builder, tag: tag, fenix: fenix);
  }

  @override
  Future<T> putAsync<T extends Object>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return Get.putAsync(builder, tag: tag, permanent: permanent);
  }

  @override
  Future<bool> delete<T extends Object>({String? tag, bool force = false}) {
    return Get.delete<T>(tag: tag, force: force);
  }

  @override
  Future<void> replace<T extends Object>(T dependency, {String? tag}) async {
    final info = GetInstance().getInstanceInfo<T>(tag: tag);
    final permanent = info.isPermanent ?? false;
    await delete<T>(tag: tag, force: permanent);
    put<T>(dependency, tag: tag, permanent: permanent);
  }

  @override
  Future<void> deleteAll({bool force = false}) {
    return Get.deleteAll(force: force);
  }

  @override
  void reset() {
    return Get.reset();
  }

  @override
  @visibleForTesting
  void testMode(bool isTest) {
    Get.testMode = true;
  }
}
