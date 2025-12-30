// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';

class AppRouterPage extends GetPage {
  final int? nestedKey;
  final bool navigator;

  AppRouterPage({
    this.nestedKey,
    this.navigator = false,
    required super.name,
    required super.page,
    super.arguments,
    super.binding,
    super.bindings,
    super.middlewares,
    super.children,
    super.popGesture = true,
    super.transition = kIsWeb ? Transition.noTransition : Transition.cupertino,
    super.transitionDuration = const Duration(milliseconds: 400),
  });

  AppRouterPage copyWith({
    String? name,
    int? nestedKey,
    bool? navigator,
    Map<String, dynamic>? arguments,
  }) {
    return AppRouterPage(
      nestedKey: nestedKey ?? this.nestedKey,
      navigator: navigator ?? this.navigator,
      name: name ?? this.name,
      page: page,
      arguments: arguments ?? this.arguments,
      binding: binding,
      bindings: bindings,
      middlewares: middlewares,
      children: children,
      popGesture: popGesture,
      transition: transition,
      transitionDuration: transitionDuration,
    );
  }
}
