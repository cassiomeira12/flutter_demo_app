import 'package:core/core.dart';

class WebViewModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    // final headless = AppBinding.put<WebViewHeadless>(
    //   WebViewHeadless(
    //     uri: Uri.parse(
    //       'https://uol.com.br?uol_app=placaruol&app_capabilities=init-metrics,comments&anchorAds=true',
    //     ),
    //   ),
    //   permanent: true,
    // );
    // await headless.run();
  }
}
