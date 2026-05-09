import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mocks.dart';

/// Usage: O aplicativo não possui permissões
Future<void> oAplicativoNaoPossuiPermissoes(WidgetTester tester) async {
  AppBinding.put<AppPermissionsService>(
    AppPermissionsServiceMock(
      status: {
        Permission.notification: PermissionStatus.denied,
        Permission.location: PermissionStatus.denied,
        Permission.camera: PermissionStatus.denied,
      },
    ),
  );

  AppBinding.put<AppEnvironmentEntity>(
    AppEnvironmentEntity(
      appName: const String.fromEnvironment('app_name'),
      androidPackageName: const String.fromEnvironment(
        'android_package_name',
      ),
      appleStoreAppId: const String.fromEnvironment('apple_store_app_id'),
      permissions: '',
    ),
    permanent: true,
  );
}
