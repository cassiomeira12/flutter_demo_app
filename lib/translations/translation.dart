import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'pt_br_translation.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      ...PtBrTranslation().keys,
    };
  }

  static Locale get fallbackLocale {
    var firstEntry = Translation().keys.entries.first;
    List<String> split = firstEntry.key.split('_');
    String languageCode = split.first;
    String? countryCode = split.length > 1 ? split.last : null;
    return Locale(languageCode, countryCode);
  }

  static List<Locale> get supportedLocales {
    return Translation().keys.entries.map((entry) {
      List<String> split = entry.key.split('_');
      String languageCode = split.first;
      String? countryCode = split.length > 1 ? split.last : null;
      return Locale(languageCode, countryCode);
    }).toList();
  }
}
