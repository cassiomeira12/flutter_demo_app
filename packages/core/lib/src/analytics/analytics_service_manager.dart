import 'package:core/core.dart';
import 'package:core/src/analytics/analytics_service_faker.dart';
import 'package:core/src/analytics/mixins/mixin.dart';
import 'package:dependency/dependency.dart';

class AnalyticsServiceManager
    with FallbackEventsMixin
    implements AnalyticsService {
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
    final initializedServices = List<AnalyticsService>.empty(growable: true);

    for (final service in services) {
      try {
        await service.init();
        initializedServices.add(service);
        Log.success(
          '${service.runtimeType} init successful',
          throwsCrashlytics: false,
        );
      } catch (error, stackTrace) {
        Log.error(error, stackTrace, msg: '$runtimeType init ERROR');
      }
    }

    if (initializedServices.isEmpty || !kReleaseMode) {
      final fallback = AnalyticsServiceFaker();
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
      sendAllUninitializedEvents();
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    Log.info('userId: $userId');
    if (_initializedServices.isEmpty) {
      return saveUserId(userId);
    }
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
    if (_initializedServices.isEmpty) {
      return saveUserProperty(name: name, property: property);
    }
    await _runServiceFunction((service) {
      return service.setUserProperty(name: name, property: property);
    });
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (_initializedServices.isEmpty) {
      return saveLog(name: name, parameters: parameters);
    }
    await _runServiceFunction((service) {
      return service.logEvent(name: name, parameters: parameters);
    });
  }
}
