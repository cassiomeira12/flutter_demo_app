import 'package:analytics/src/data/aptabase_storage_manager.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AptabaseAnalytics implements AnalyticsService {
  final String _apiKey;
  final String _apiUrl;

  AptabaseAnalytics({required this._apiKey, required this._apiUrl});

  @override
  Future<void> init() async {
    if (Platform.isWeb) {
      Log.info('Aptabase is not supported on Web');
      return;
    }

    final StorageManager storageManager = AptabaseStorageManager();
    await storageManager.init();

    Aptabase.init(
      _apiKey,
      InitOptions(host: _apiUrl, printDebugMessages: !kReleaseMode),
      storageManager,
    );
  }

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    Map<String, dynamic>? property,
  }) async {
    if (kIsWeb) {
      Log.info('Aptabase is not supported on Web');
      return;
    }
    await Aptabase.instance.trackEvent(name, property);
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    if (kIsWeb) {
      Log.info('Aptabase is not supported on Web');
      return;
    }
    await Aptabase.instance.trackEvent(name, parameters);
  }
}
