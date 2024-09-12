import 'package:get/get.dart';

enum AppRouter {
  splash('/'),
  login('/login'),
  home('/home'),
  emergency('/emergency'),
  contacts('/contacts'),
  settings('/settings');

  const AppRouter(this._name);

  final String _name;

  String get name => _name;

  static Future<T?> toNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return Get.toNamed(
      route.name,
      id: id,
      // parameters: id != null ? {'id': '$id'} : null,
    );
  }

  static Future<T?> offAndToNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return Get.offAndToNamed(
      route.name,
      id: id,
      parameters: id != null ? {'id': '$id'} : null,
    );
  }

  static Future<T?> offAllNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return Get.offAllNamed<T>(
      route.name,
      id: id,
      parameters: id != null ? {'id': '$id'} : null,
    );
  }
}
