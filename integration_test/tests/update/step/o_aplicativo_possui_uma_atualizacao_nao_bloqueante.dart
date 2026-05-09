import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/services/feature_flag_service_mock.dart';

/// Usage: O aplicativo possui uma atualização não bloqueante
Future<void> oAplicativoPossuiUmaAtualizacaoNaoBloqueante(
  WidgetTester tester,
) async {
  FeatureFlagServiceManager.instance.services.add(
    FeatureFlagServiceMock(
      initialValues: {
        RemoteFlagsEnum.updateApp: RemoteFlag<bool>(
          isEnabled: true,
          value: true,
        ),
        RemoteFlagsEnum.updateAppRequired: RemoteFlag<bool>(
          isEnabled: false,
          value: false,
        ),
        RemoteFlagsEnum.blockingApp: RemoteFlag<bool>(
          isEnabled: false,
          value: false,
        ),
        RemoteFlagsEnum.downloadAndroidStore: RemoteFlag<bool>(
          isEnabled: false,
          value: false,
        ),
        RemoteFlagsEnum.downloadAppleStore: RemoteFlag<bool>(
          isEnabled: false,
          value: false,
        ),
        RemoteFlagsEnum.sentryConfig: RemoteFlag<Map<String, dynamic>>(
          isEnabled: false,
          value: {},
        ),
      },
    ),
  );
}
