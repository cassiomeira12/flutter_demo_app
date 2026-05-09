import 'package:core/core.dart';

class FeatureFlagServiceMock implements FeatureFlagService {
  final Map<RemoteFlagsEnum, RemoteFlag> _values;

  FeatureFlagServiceMock({
    required Map<RemoteFlagsEnum, RemoteFlag> initialValues,
  }) : _values = initialValues;

  @override
  Future<void> init() async {}

  @override
  Future<RemoteFlag<T>> getFlag<T>(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    return _values[flag]! as RemoteFlag<T>;
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {}

  @override
  void setUserId(String? userId) {}
}
