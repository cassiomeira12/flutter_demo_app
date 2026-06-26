import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mocks.dart';

/// Usage: O aplicativo possui as persmissões <permission>
Future<void> oAplicativoPossuiAsPersmissoes(
  WidgetTester tester,
  String permission,
) async {
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
      permissions: permission,
      webBaseHREF: const String.fromEnvironment('baseHREF'),
    ),
    permanent: true,
  );
}
