import 'package:core/core.dart';

abstract class FeatureFlagService {
  Future<void> init();

  void setUserId(String? userId);

  Future<void> setTraits(DeviceTraits traits);

  Future<RemoteFlag<T>> getFlag<T>(
    RemoteFlagsEnum flag, {
    bool reload = false,
  });
}
