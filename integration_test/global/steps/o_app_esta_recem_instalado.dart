import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/translations/translation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/infra/local_storage_mock.dart';

/// Usage: O app está recém instalado
Future<void> oAppEstaRecemInstalado(WidgetTester tester) async {
  AppTranslation.initLocales();
  ThemeManager.instance.defineColor();
  BaseController.SPLASH_ALREADY_EXECUTED = false;
  SharedPreferences.setMockInitialValues({});

  await AppBinding.deleteAll(force: true);

  if (AppBinding.hasInstance<LocalStorage>()) {
    await AppBinding.delete<LocalStorage>();
  }

  AppBinding.put<LocalStorage>(LocalStorageMock(), permanent: true);
  FeatureFlagServiceManager.instance.clear();
}
