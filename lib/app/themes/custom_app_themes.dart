import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class WebViewLightColorScheme extends LightColorScheme {
  WebViewLightColorScheme({required super.color});

  @override
  double get appBarElevation => 1.0;

  @override
  Color get appBarColor => highlightBackgroundColor;
}

class WebViewDarkColorScheme extends DarkColorScheme {
  WebViewDarkColorScheme({required super.color});

  @override
  double get appBarElevation => 1.0;

  @override
  Color get appBarColor => highlightBackgroundColor;
}
