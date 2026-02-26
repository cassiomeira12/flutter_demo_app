import 'package:core/core.dart';

class FeatureFlagServiceManager implements FeatureFlagService {
  FeatureFlagServiceManager._();

  static final instance = FeatureFlagServiceManager._();

  final List<FeatureFlagService> services = List.empty(growable: true);

  final List<FeatureFlagService> _initializedServices = List.empty(
    growable: true,
  );

  Future<void> _runServiceFunction(
    Function(FeatureFlagService service) function,
  ) {
    return Future.wait(
      _initializedServices.map((service) => function(service)),
    );
  }

  @override
  Future<void> init() async {
    bool useFallbackService = false;

    for (final service in services) {
      try {
        await service.init();
        _initializedServices.add(service);
        Log.success(
          '${service.runtimeType} init successful',
          throwsCrashlytics: false,
        );
      } catch (error, stackTrace) {
        if (!useFallbackService) {
          useFallbackService = true;
        }
        Log.error(
          '$runtimeType init ERROR',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (services.isNotEmpty) {
      for (final service in _initializedServices) {
        services.remove(service);
      }
    }

    if (useFallbackService || _initializedServices.isEmpty) {
      final fallback = FeatureFlagServiceFaker();
      await fallback.init();
      _initializedServices.add(fallback);
    }
  }

  @override
  Future<RemoteFlag?> getFlag(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    return await _initializedServices.first.getFlag(flag, reload: reload);
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {
    await _runServiceFunction((service) => service.setTraits(traits));
  }

  @override
  void setUserId(String? userId) {
    _runServiceFunction(
      (service) async => service.setUserId(userId),
    );
  }
}
