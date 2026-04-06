import 'package:core/core.dart';
import 'package:core/src/crashlytics/crashlytics_service_faker.dart';
import 'package:core/src/crashlytics/mixins/mixin.dart';
import 'package:dependency/dependency.dart';

class CrashlyticsServiceManager
    with FallbackEventsMixin, FallbackTrackOperationsMixin
    implements CrashlyticsService {
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
      _initializedServices.map((service) async {
        try {
          await function(service);
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
        }
      }),
    );
  }

  @override
  Future<void> init() async {
    final initializedServices = List<CrashlyticsService>.empty(growable: true);

    for (final service in services) {
      try {
        await service.init();
        initializedServices.add(service);
        Log.success(
          '${service.runtimeType} init successful',
          throwsCrashlytics: false,
        );
      } catch (error, stackTrace) {
        saveExceptions(
          message: '${service.runtimeType} init error',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (initializedServices.isEmpty || !kReleaseMode) {
      final fallback = CrashlyticsServiceFaker();
      await fallback.init();
      initializedServices.add(fallback);
    }

    _initializedServices.addAll(initializedServices);

    if (services.isNotEmpty) {
      for (final service in _initializedServices) {
        services.remove(service);
      }
    }

    if (_initializedServices.isNotEmpty) {
      _sendFallbackEvents();
    }
  }

  Future<void> _sendFallbackEvents() async {
    await sendAllUninitializedEvents();
    sendAllUninitializedTrackOperation();
  }

  @override
  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.debug,
  }) {
    if (_initializedServices.isEmpty) {
      return saveLog(message, level: level);
    }
    _runServiceFunction(
      (service) async => service.log(
        message,
        level: level,
        type: type,
      ),
    );
  }

  @override
  void logHttp(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.http,
  }) {
    if (_initializedServices.isEmpty) {
      return saveLogHttp(message, level: level, type: type);
    }
    _runServiceFunction(
      (service) async => service.logHttp(
        message,
        level: level,
        type: type,
      ),
    );
  }

  @override
  void logUserInteraction(
    String event, {
    Map<String, dynamic>? parameters,
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.user,
  }) {
    if (_initializedServices.isEmpty) {
      return saveLogUserInteraction(
        event,
        parameters: parameters,
        level: level,
        type: type,
      );
    }
    _runServiceFunction(
      (service) async => service.logUserInteraction(
        event,
        parameters: parameters,
        level: level,
        type: type,
      ),
    );
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (_initializedServices.isEmpty) {
      return saveUserId(userId);
    }
    return _runServiceFunction((service) => service.setUserId(userId));
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {
    if (_initializedServices.isEmpty) {
      return saveUserProperty(name: name, property: property);
    }
    return _runServiceFunction((service) {
      return service.setUserProperty(name: name, property: property);
    });
  }

  @override
  void setIpAddress(IpAddressLocationEntity ipAddress) {
    if (_initializedServices.isEmpty) {
      return saveIpAddress(ipAddress);
    }
    _runServiceFunction((service) async => service.setIpAddress(ipAddress));
  }

  @override
  Future<void> captureException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) async {
    if (_initializedServices.isEmpty) {
      return saveExceptions(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
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
  }) async {
    if (_initializedServices.isEmpty) {
      return saveFatalExceptions(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
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
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    if (_initializedServices.isEmpty) {
      return UninitializedTrackOperation(
        name: name,
        description: description,
        startTimestamp: startTimestamp ?? DateTime.timestamp(),
        onFinishedOperation: (UninitializedTrackOperation parent) {
          if (_initializedServices.isEmpty) {
            saveUninitializedTrackOperation(parent);
          } else {
            callbackFinishedTrackOperation(parent);
          }
        },
      );
    }
    return CollectionTrackOperation(
      _initializedServices.map((service) {
        return service.trackOperation(
          name: name,
          description: description,
          startTimestamp: startTimestamp,
        );
      }).toList(),
    );
  }

  @override
  void simulateCrash() {
    _runServiceFunction((service) async => service.simulateCrash());
  }
}
