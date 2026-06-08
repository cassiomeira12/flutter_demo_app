import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ChangeLocaleNativeMethod {
  final MethodChannel _methodChannel;

  const ChangeLocaleNativeMethod({required this._methodChannel});

  Future<void> call(Locale locale) async {
    try {
      final String localeName = locale.languageCode;
      await _methodChannel.invokeMethod(
        NativeMethodEnum.changeLocale.name,
        localeName,
      );
    } on MissingPluginException {
      // do nothing
    }
  }
}
