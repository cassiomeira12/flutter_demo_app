import 'package:core/src/bindings/app_base_binding.dart';
import 'package:dependency/dependency.dart';

class GetItBinding implements AppBaseBinding {
  GetItBinding._();

  static final instance = GetItBinding._();

  @override
  bool hasInstance<T extends Object>({String? tag}) {
    return GetIt.instance.isRegistered<T>(instanceName: tag);
  }

  @override
  T find<T extends Object>({String? tag}) {
    return GetIt.instance.get<T>(instanceName: tag);
  }

  @override
  T put<T extends Object>(T dependency, {String? tag, bool permanent = false}) {
    return GetIt.instance.registerSingleton<T>(dependency, instanceName: tag);
  }

  @override
  void create<T extends Object>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    return GetIt.instance.registerFactory<T>(builder, instanceName: tag);
  }

  @override
  void lazyPut<T extends Object>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  }) {
    // return GetIt.instance.registerFactory<T>( ?
    // return GetIt.instance.registerLazySingleton<T>( ?
    return GetIt.instance.registerFactory<T>(
      builder,
      instanceName: tag,
    );
  }

  @override
  Future<T> putAsync<T extends Object>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  }) {
    final completer = Completer<T>();
    GetIt.instance.registerSingletonAsync<T>(
      builder,
      instanceName: tag,
      onCreated: completer.complete,
    );
    return completer.future;
  }

  @override
  Future<bool> delete<T extends Object>({
    String? tag,
    bool force = false,
  }) async {
    await GetIt.instance.unregister<T>(instanceName: tag);
    return true;
  }

  @override
  Future<void> replace<T extends Object>(T dependency, {String? tag}) async {
    await GetIt.instance.unregister<T>(instanceName: tag);
    GetIt.instance.registerSingleton<T>(dependency, instanceName: tag);
  }

  @override
  Future<void> deleteAll({bool force = false}) {
    return GetIt.instance.reset();
  }

  @override
  void reset() {
    GetIt.instance.reset(dispose: false);
  }

  @override
  @visibleForTesting
  void testMode(bool isTest) {}
}
