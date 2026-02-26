import 'package:core/core.dart';
import 'package:core/src/analytics/analytics_service_faker.dart';

class AnalyticsServiceManager implements AnalyticsService {
  AnalyticsServiceManager._();

  static final instance = AnalyticsServiceManager._();

  final List<AnalyticsService> services = List.empty(growable: true);

  final List<AnalyticsService> _initializedServices = List.empty(
    growable: true,
  );

  Future<void> _runServiceFunction(
    Function(AnalyticsService service) function,
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
      final fallback = AnalyticsServiceFaker();
      await fallback.init();
      _initializedServices.add(fallback);
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    Log.info('userId: $userId');
    await _runServiceFunction((service) => service.setUserId(userId));
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {
    Log.info(
      'Event: $name \n'
      'Parameters: $property',
    );
    await _runServiceFunction((service) {
      return service.setUserProperty(name: name, property: property);
    });
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _runServiceFunction((service) {
      return service.logEvent(name: name, parameters: parameters);
    });
  }
}
