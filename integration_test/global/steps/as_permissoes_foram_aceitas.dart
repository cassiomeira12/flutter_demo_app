import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

/// Usage: As permissões foram aceitas
Future<void> asPermissoesForamAceitas(WidgetTester tester) async {
  AppBinding.put<AppPermissionsService>(
    AppPermissionsServiceMock(
      status: {
        Permission.notification: PermissionStatus.granted,
        Permission.location: PermissionStatus.granted,
        Permission.camera: PermissionStatus.granted,
      },
    ),
  );
}
