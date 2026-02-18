import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/src/data/data.dart';

class FlagsmithFeatureFlag implements FeatureFlagService {
  final String apiKey;
  final String baseURI;
  final String? initialConfigJson;
  final LocalStorageUseCase _localStorage;

  FlagsmithFeatureFlag({
    required this.apiKey,
    required this.baseURI,
    this.initialConfigJson,
    required LocalStorageUseCase localStorageUseCase,
  }) : _localStorage = localStorageUseCase;

  late FlagsmithClient _client;

  Identity? _deviceIdentity;
  final Map<String, Trait> _traits = {};

  @override
  Future<void> init() async {
    late Map<String, dynamic> initialOfflineConfigs;

    try {
      final String path = initialConfigJson!;
      final String initialOfflineConfigsFile = await rootBundle.loadString(
        path,
      );
      initialOfflineConfigs = jsonDecode(initialOfflineConfigsFile);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      initialOfflineConfigs = {};
    }

    _client = FlagsmithClient(
      apiKey: apiKey,
      config: FlagsmithConfig(
        baseURI: baseURI,
        storageType: StorageType.custom,
        caches: true,
        isDebug: kDebugMode,
        enableAnalytics: kReleaseMode,
      ),
      storage: SharedPreferencesStore(localStorageUseCase: _localStorage),
      seeds: List.from(initialOfflineConfigs['flags'] ?? []).map((json) {
        return Flag.fromJson(json);
      }).toList(),
    );

    await _client.initialize();
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {
    _deviceIdentity = Identity(identifier: traits.deviceId);
    for (final param in traits.toMap().entries) {
      _traits[param.key] = Trait(key: param.key, value: param.value);
    }
    await _client.getFeatureFlags(
      user: _deviceIdentity,
      traits: _traits.values.toList(),
    );
  }

  @override
  void setUserIdentifier(String? userId, {Map<String, dynamic>? property}) {
    _traits['userId'] = Trait(key: 'userId', value: userId);
  }

  @override
  Future<RemoteFlag?> getFlag(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    final bool hasFlag = await _client.hasFeatureFlag(
      flag.name,
      user: _deviceIdentity,
      reload: reload,
    );
    if (hasFlag) {
      final bool enabled = await _client.isFeatureFlagEnabled(
        flag.name,
        user: _deviceIdentity,
      );
      final String? value = await _client.getFeatureFlagValue(
        flag.name,
        user: _deviceIdentity,
      );
      return RemoteFlag(isEnabled: enabled, value: value);
    }
    return null;
  }
}
