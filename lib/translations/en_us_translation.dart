import 'package:core/core.dart';

class AppEnUsTranslation extends EnUsTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app': 'A tool to help combat violence against women.',
      },
    };
  }
}
