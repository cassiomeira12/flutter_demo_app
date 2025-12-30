import 'package:core/core.dart';
import 'package:flutter_demo_app/translations/en_us_translation.dart';
import 'package:flutter_demo_app/translations/pt_br_translation.dart';

class AppTranslation extends Translation {
  static void initLocales() {
    Translation.locales = {
      ...AppPtBrTranslation().keys,
      ...AppEnUsTranslation().keys,
    };
  }
}
