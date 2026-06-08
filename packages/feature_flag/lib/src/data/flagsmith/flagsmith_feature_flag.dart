import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/src/data/data.dart';
import 'package:feature_flag/src/data/mixin/parse_value_mixin.dart';

class FlagsmithFeatureFlag with ParseValueMixin implements FeatureFlagService {
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
      Log.error(error, stackTrace, msg: 'initialOfflineConfigs');
      initialOfflineConfigs = {};
    }

    _client = FlagsmithClient(
      apiKey: apiKey,
      config: FlagsmithConfig(
        baseURI: baseURI,
        storageType: StorageType.custom,
        caches: true,
        isDebug: !kReleaseMode,
        enableAnalytics: false,
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
    try {
      _deviceIdentity = Identity(identifier: traits.deviceId);
      for (final param in traits.toMap().entries) {
        _traits[param.key] = Trait(key: param.key, value: param.value);
      }
      final list = await _client.getFeatureFlags(
        user: _deviceIdentity,
        traits: _traits.values.toList(),
      );
      _sendAnalyticsFlags(list);
    } on FlagsmithApiException catch (_) {
      // ignore Api Exceptions
    } catch (_) {
      rethrow;
    }
  }

  @override
  void setUserId(String? userId) {
    _traits['userId'] = Trait(key: 'userId', value: userId ?? 'null');
  }

  @override
  Future<RemoteFlag<T>> getFlag<T>(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    try {
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
        return parseValueType<T>(flag: flag, isEnabled: enabled, value: value);
      }
      return RemoteFlag<T>(isEnabled: false, value: null);
    } on FlagsmithApiException catch (_) {
      // ignore Api Exceptions
      return RemoteFlag<T>(isEnabled: false, value: null);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _sendAnalyticsFlags(List<Flag> flags) async {
    for (final flag in flags) {
      AnalyticsServiceManager.instance.logEvent(
        'feature_flag_flagsmith',
        parameters: {
          flag.feature.name:
              'enabled: ${flag.enabled} value: ${flag.stateValue}',
        },
      );
    }
  }
}
