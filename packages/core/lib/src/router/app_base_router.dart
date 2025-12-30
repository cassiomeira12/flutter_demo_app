import 'package:dependency/dependency.dart';

abstract class AppBaseRouter {
  Future<dynamic>? to(Widget Function() page, {int? id});

  Future<dynamic>? toNamed(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
    Map<String, dynamic>? arguments,
  });

  void back({int? id, dynamic result});

  Future<dynamic>? backAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  });

  Future<dynamic>? backAllAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  });

  Future<dynamic>? offNamedUntil(
    String routeName, {
    int? id,
    required String stopRoute,
  });
}
