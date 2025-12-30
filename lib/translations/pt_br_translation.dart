import 'package:core/core.dart';

class AppPtBrTranslation extends PtBrTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
      },
    };
  }
}
