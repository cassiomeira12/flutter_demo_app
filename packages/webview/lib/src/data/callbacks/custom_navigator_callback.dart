import 'package:dependency/dependency.dart';
import 'package:webview/src/domain/domain.dart';

class CustomNavigatorCallbackImpl implements CustomNavigatorCallback {
  @override
  Future<NavigationActionPolicy?> call(
    NavigationAction navAction,
    void Function(String url) click,
    void Function(String log) onLog, {
    required bool isRedirect,
    required bool hasGesture,
    required bool userClicked,
    required Uri uri,
    Uri? originalUri,
    Uri? lastUriLoaded,
  }) async {
    final String url = uri.toString();

    // open flash Urls
    // https://www.uol.com.br/flash/?c=4cc0d664b0a3a950e481478d21c42ae520260516
    final flash = RegExp(r'^https:\/\/www\.uol\.com\.br\/flash\/\?c=.+$');
    if (flash.hasMatch(uri.toString())) {
      click(url); // Ou trocar de Aba
      onLog('shouldOverrideUrlLoading CustomAction Click Flash [CANCEL]');
      return NavigationActionPolicy.CANCEL;
    }

    // https://www.uol.com.br/esporte/futebol/campeonatos/brasileirao/
    final championships = RegExp(
      r'^https:\/\/www\.uol\.com\.br\/esporte\/futebol\/campeonatos\/.*$',
    );
    if (championships.hasMatch(uri.toString())) {
      click(url); // Ou trocar de Aba
      onLog('shouldOverrideUrlLoading CustomAction Click Campeonatos [CANCEL]');
      return NavigationActionPolicy.CANCEL;
    }

    return null;
  }
}
