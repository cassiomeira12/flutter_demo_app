// ignore_for_file: overridden_fields

import 'package:dependency/dependency.dart';

class AppRouterPage extends GetPage {
  final int? nestedKey;
  final bool navigator;

  @override
  final bool canPop;

  AppRouterPage({
    this.nestedKey,
    this.navigator = false,
    this.canPop = true,
    required super.name,
    required super.page,
    super.arguments,
    super.binding,
    super.bindings,
    super.middlewares,
    super.children,
    super.transition = kIsWeb ? Transition.noTransition : Transition.cupertino,
    super.transitionDuration = const Duration(milliseconds: 400),
  }) : super(popGesture: canPop);

  AppRouterPage copyWith({
    String? name,
    int? nestedKey,
    bool? navigator,
    Map<String, dynamic>? arguments,
  }) {
    return AppRouterPage(
      nestedKey: nestedKey ?? this.nestedKey,
      navigator: navigator ?? this.navigator,
      canPop: canPop,
      name: name ?? this.name,
      page: page,
      arguments: arguments ?? this.arguments,
      binding: binding,
      bindings: bindings,
      middlewares: middlewares,
      children: children,
      transition: transition,
      transitionDuration: transitionDuration,
    );
  }
}
