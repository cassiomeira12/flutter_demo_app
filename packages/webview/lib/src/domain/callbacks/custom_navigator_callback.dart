import 'package:dependency/dependency.dart';

abstract class CustomNavigatorCallback {
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
  });
}
