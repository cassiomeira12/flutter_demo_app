import 'package:core/src/bindings/app_base_binding.dart';
import 'package:dependency/dependency.dart';

class GetBinding implements AppBaseBinding {
  GetBinding._();

  static final instance = GetBinding._();

  @override
  bool hasInstance<T>({String? tag}) {
    return Get.isRegistered<T>(tag: tag);
  }

  @override
  T find<T>({String? tag}) {
    return Get.find<T>(tag: tag);
  }

  @override
  T put<T>(T dependency, {String? tag, bool permanent = false}) {
    return Get.put<T>(dependency, tag: tag, permanent: permanent);
  }

  @override
  void create<T>(T Function() builder, {String? tag, bool permanent = false}) {
    Get.create<T>(builder, tag: tag, permanent: permanent);
  }

  @override
  void lazyPut<T>(T Function() builder, {String? tag, bool fenix = true}) {
    Get.lazyPut<T>(builder, tag: tag, fenix: fenix);
  }

  @override
  Future<T> putAsync<T>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return Get.putAsync(builder, tag: tag, permanent: permanent);
  }

  @override
  Future<bool> delete<T>({String? tag, bool force = false}) {
    return Get.delete<T>(tag: tag, force: force);
  }

  @override
  Future<void> replace<T>(T dependency, {String? tag}) async {
    Get.replace<T>(dependency, tag: tag);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> deleteAll({bool force = false}) {
    return Get.deleteAll(force: force);
  }
}
