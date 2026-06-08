import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

mixin FallbackEventsMixin {
  final List<Map<String, dynamic>> _fallbackLogs = List.empty(growable: true);
  final List<Map<String, dynamic>> _fallbackLogsHttp = List.empty(
    growable: true,
  );
  final List<Map<String, dynamic>> _fallbackLogsUserInteraction = List.empty(
    growable: true,
  );
  final List<Map<String, dynamic>> _fallbackUserId = List.empty(growable: true);
  final List<Map<String, dynamic>> _fallbackUserProperty = List.empty(
    growable: true,
  );
  final List<Map<String, dynamic>> _fallbackIpAddress = List.empty(
    growable: true,
  );
  final List<Map<String, dynamic>> _fallbackExceptions = List.empty(
    growable: true,
  );

  Future<void> sendAllUninitializedEvents() async {
    final snapshotLogs = List.from(_fallbackLogs);
    final snapshotLogsHttp = List.from(_fallbackLogsHttp);
    final snapshotLogsUserInteraction = List.from(_fallbackLogsUserInteraction);
    final snapshotUserId = List.from(_fallbackUserId);
    final snapshotUserProperty = List.from(_fallbackUserProperty);
    final snapshotIpAddress = List.from(_fallbackIpAddress);
    final snapshotExceptions = List.from(_fallbackExceptions);

    _fallbackLogs.clear();
    _fallbackLogsHttp.clear();
    _fallbackLogsUserInteraction.clear();
    _fallbackUserId.clear();
    _fallbackUserProperty.clear();
    _fallbackIpAddress.clear();
    _fallbackExceptions.clear();

    for (final map in snapshotLogs) {
      CrashlyticsServiceManager.instance.log(
        map['message'],
        level: map['level'],
      );
    }

    for (final map in snapshotLogsHttp) {
      CrashlyticsServiceManager.instance.logHttp(
        map['message'],
        level: map['level'],
        type: map['type'],
      );
    }

    for (final map in snapshotLogsUserInteraction) {
      CrashlyticsServiceManager.instance.logUserInteraction(
        map['event'],
        parameters: map['parameters'],
        level: map['level'],
        type: map['type'],
      );
    }

    for (final map in snapshotUserId) {
      await CrashlyticsServiceManager.instance.setUserId(map['userId']);
    }

    for (final map in snapshotUserProperty) {
      await CrashlyticsServiceManager.instance.setUserProperty(
        name: map['name'],
        property: map['property'],
      );
    }

    for (final map in snapshotIpAddress) {
      CrashlyticsServiceManager.instance.setIpAddress(map['ipAddress']);
    }

    for (final map in snapshotExceptions) {
      if (map['error'] != null) {
        if (map['fatal'] ?? false) {
          await CrashlyticsServiceManager.instance.captureFatalException(
            message: map['message'],
            error: map['error'],
            stackTrace: map['stackTrace'],
          );
        } else {
          await CrashlyticsServiceManager.instance.captureException(
            message: map['message'],
            error: map['error'],
            stackTrace: map['stackTrace'],
          );
        }
      }
    }
  }

  void saveLog(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
  }) {
    return _fallbackLogs.add({'message': message, 'level': level});
  }

  void saveLogHttp(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.http,
  }) {
    return _fallbackLogsHttp.add({
      'message': message,
      'level': level,
      'type': type,
    });
  }

  void saveLogUserInteraction(
    String event, {
    Map<String, dynamic>? parameters,
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.user,
  }) {
    return _fallbackLogsUserInteraction.add({
      'event': event,
      'parameters': parameters,
      'level': level,
      'type': type,
    });
  }

  void saveUserId(String? userId) {
    return _fallbackUserId.add({'userId': userId});
  }

  void saveUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) {
    return _fallbackUserProperty.add({'name': name, 'property': property});
  }

  void saveIpAddress(IpAddressLocationEntity ipAddress) {
    return _fallbackIpAddress.add({'ipAddress': ipAddress});
  }

  void saveExceptions({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return _fallbackExceptions.add({
      'fatal': false,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
    });
  }

  void saveFatalExceptions({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return _fallbackExceptions.add({
      'fatal': true,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
    });
  }
}
