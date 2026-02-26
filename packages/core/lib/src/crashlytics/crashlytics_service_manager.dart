import 'package:core/core.dart';
import 'package:core/src/crashlytics/crashlytics_service_faker.dart';

class CrashlyticsServiceManager implements CrashlyticsService {
  CrashlyticsServiceManager._();

  static final instance = CrashlyticsServiceManager._();

  final List<CrashlyticsService> services = List.empty(growable: true);

  final List<CrashlyticsService> _initializedServices = List.empty(
    growable: true,
  );

  final List<dynamic> _errors = List.empty(growable: true);
  final List<dynamic> _stackTraces = List.empty(growable: true);

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
        _errors.add(error);
        _stackTraces.add(stackTrace);
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
    }

    for (int i = 0; i < _errors.length; i++) {
      StackTrace? stackTrace;
      try {
        stackTrace = _stackTraces[i];
      } catch (_) {}
      captureException(error: _errors[i], stackTrace: stackTrace);
    }

    _errors.clear();
    _stackTraces.clear();
  }

  @override
  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
  }) {
    _runServiceFunction((service) async => service.log(message, level: level));
  }

  @override
  Future<void> setUserId(String? userId) {
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
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (_initializedServices.isEmpty) {
      _errors.add(error);
      _stackTraces.add(stackTrace);
    }
    return _runServiceFunction((service) {
      return service.captureException(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    });
  }

  @override
  Future<void> captureFatalException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (_initializedServices.isEmpty) {
      _errors.add(error);
      _stackTraces.add(stackTrace);
    }
    return _runServiceFunction((service) {
      return service.captureFatalException(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    });
  }

  @override
  TrackOperation trackOperation({
    String? name,
    String? operation,
    DateTime? startTimestamp,
  }) {
    return _initializedServices.first.trackOperation(
      name: name,
      operation: operation,
      startTimestamp: startTimestamp,
    );
  }

  @override
  void simulateCrash() {
    _runServiceFunction((service) async => service.simulateCrash());
  }
}
