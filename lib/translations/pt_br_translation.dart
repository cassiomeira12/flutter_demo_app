import 'package:core/core.dart';

class AppPtBrTranslation extends PtBrTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app':
            'Uma ferramenta para ajudar no combate à violência contra a mulher.',
      },
    };
  }
}
