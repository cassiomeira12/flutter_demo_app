import 'package:core/core.dart';

class FeatureFlagServiceFaker implements FeatureFlagService {
  @override
  Future<void> init() async {}

  @override
  Future<RemoteFlag<T>> getFlag<T>(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    return RemoteFlag<T>(isEnabled: false, value: null);
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {
    if (!Log.isIntegrationTest) {
      Log.info('setTraits traits: ${traits.toMap()}');
    }
  }

  @override
  void setUserId(String? userId) {
    if (!Log.isIntegrationTest) {
      Log.info('setUserIdentifier userId: $userId');
    }
  }
}
