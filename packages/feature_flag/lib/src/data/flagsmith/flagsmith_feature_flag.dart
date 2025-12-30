import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'shared_preferences_store.dart';

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

  Identity? _user;
  final Map<String, Trait> _traits = {};

  @override
  Future<void> init({Map<String, dynamic>? initConfigs}) async {
    late Map<String, dynamic> initialOfflineConfigs;

    if (initConfigs != null) {
      initialOfflineConfigs = initConfigs;
    } else {
      try {
        final String path = initialConfigJson!;
        final String initialOfflineConfigsFile = await rootBundle.loadString(
          path,
        );
        initialOfflineConfigs = jsonDecode(initialOfflineConfigsFile);
      } catch (_) {
        initialOfflineConfigs = {};
      }
    }

    _client = FlagsmithClient(
      apiKey: apiKey,
      config: FlagsmithConfig(
        baseURI: baseURI,
        storageType: StorageType.custom,
        caches: true,
        enableAnalytics: false,
        isDebug: kDebugMode,
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
    if (_user == null) return;
    for (final param in traits.toMap().entries) {
      _traits[param.key] = Trait(key: param.key, value: param.value);
    }
    await _client.getFeatureFlags(user: _user, traits: _traits.values.toList());
  }

  @override
  void setUserIdentifier(String? userId, {Map<String, dynamic>? property}) {
    _user = Identity(identifier: userId ?? '');
  }

  @override
  Future<RemoteFlag?> getFlag(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    final bool hasFlag = await _client.hasFeatureFlag(
      flag.name,
      user: _user,
      reload: reload,
    );
    if (hasFlag) {
      final bool enabled = await _client.isFeatureFlagEnabled(
        flag.name,
        user: _user,
      );
      final String? value = await _client.getFeatureFlagValue(
        flag.name,
        user: _user,
      );
      return RemoteFlag(isEnabled: enabled, value: value);
    }
    return null;
  }
}
