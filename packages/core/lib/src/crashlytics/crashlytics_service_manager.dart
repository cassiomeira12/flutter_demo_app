import 'package:core/core.dart';

import 'crashlytics_service_faker.dart';

class CrashlyticsServiceManager implements CrashlyticsService {
  CrashlyticsServiceManager._();

  static final instance = CrashlyticsServiceManager._();

  final List<CrashlyticsService> services = List.empty(growable: true);

  final List<CrashlyticsService> _initializedServices = List.empty(
    growable: true,
  );

  Future<void> _runServiceFunction(
    Future<void> Function(CrashlyticsService service) function,
  ) {
    return Future.wait(
      _initializedServices.map((service) => function(service)),
    );
  }

  @override
  Future<void> init() async {
    bool useFallbackService = false;

    final List<dynamic> errors = List.empty(growable: true);
    final List<dynamic> stackTraces = List.empty(growable: true);

    for (final service in services) {
      try {
        await service.init();
        _initializedServices.add(service);
        Log.info('${service.runtimeType} init successful');
      } catch (error, stackTrace) {
        if (!useFallbackService) {
          useFallbackService = true;
        }
        errors.add(error);
        stackTraces.add(stackTrace);
      }
    }

    if (services.isNotEmpty) {
      for (final service in _initializedServices) {
        services.remove(service);
      }
    }

    if (useFallbackService || _initializedServices.isEmpty) {
      final fallback = CrashlyticsServiceFaker();
      await fallback.init();
      _initializedServices.add(fallback);
      for (int i = 0; i < errors.length; i++) {
        captureException(error: errors[i], stackTrace: stackTraces[i]);
      }
    }
  }

  @override
  void log(String message) {
    _runServiceFunction((service) async => service.log(message));
  }

  @override
  Future<void> setUserId(String userId) {
    return _runServiceFunction((service) => service.setUserId(userId));
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) {
    return _runServiceFunction((service) {
      return service.setUserProperty(name: name, property: property);
    });
  }

  @override
  Future<void> captureException({
    required Object error,
    StackTrace? stackTrace,
  }) {
    return _runServiceFunction((service) {
      return service.captureException(error: error, stackTrace: stackTrace);
    });
  }

  @override
  Future<void> captureFatalException({
    required Object error,
    StackTrace? stackTrace,
  }) {
    return _runServiceFunction((service) {
      return service.captureFatalException(
        error: error,
        stackTrace: stackTrace,
      );
    });
  }
}
