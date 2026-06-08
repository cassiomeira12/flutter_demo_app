import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/data/data.dart';
import 'package:webview/src/domain/domain.dart';

class WebViewBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CustomNavigatorCallback>(
      CustomNavigatorCallbackImpl(),
      permanent: true,
    );
  }
}
