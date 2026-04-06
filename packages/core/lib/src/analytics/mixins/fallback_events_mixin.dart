import 'package:core/core.dart';

mixin FallbackEventsMixin {
  final List<Map<String, dynamic>> _fallbackLogs = List.empty(growable: true);
  final List<Map<String, dynamic>> _fallbackUserId = List.empty(growable: true);
  final List<Map<String, dynamic>> _fallbackUserProperty = List.empty(
    growable: true,
  );

  Future<void> sendAllUninitializedEvents() async {
    final snapshotLogs = List.from(_fallbackLogs);
    final snapshotUserId = List.from(_fallbackUserId);
    final snapshotUserProperty = List.from(_fallbackUserProperty);

    _fallbackLogs.clear();
    _fallbackUserId.clear();
    _fallbackUserProperty.clear();

    for (final map in snapshotLogs) {
      AnalyticsServiceManager.instance.logEvent(
        name: map['name'],
        parameters: map['parameters'],
      );
    }

    for (final map in snapshotUserId) {
      await AnalyticsServiceManager.instance.setUserId(map['userId']);
    }

    for (final map in snapshotUserProperty) {
      await AnalyticsServiceManager.instance.setUserProperty(
        name: map['name'],
        property: map['property'],
      );
    }
  }

  void saveLog({
    required String name,
    Map<String, dynamic>? parameters,
  }) {
    return _fallbackLogs.add({'name': name, 'parameters': parameters});
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
}
