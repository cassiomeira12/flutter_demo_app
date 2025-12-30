import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AptabaseAnalytics implements AnalyticsService {
  final String _apiKey;
  final String _apiUrl;

  AptabaseAnalytics({required String apiKey, required String apiUrl})
    : _apiKey = apiKey,
      _apiUrl = apiUrl;

  @override
  Future<void> init() async {
    if (Platform.isWeb) {
      Log.info('Aptabase is not supported on Web');
      return;
    }
    await Aptabase.init(
      _apiKey,
      InitOptions(host: _apiUrl, printDebugMessages: true),
    );
  }

  @override
  Future<void> setUserId(String userId) async {}

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
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (kIsWeb) {
      Log.info('Aptabase is not supported on Web');
      return;
    }
    await Aptabase.instance.trackEvent(name, parameters);
  }
}
