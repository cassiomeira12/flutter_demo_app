import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../scaffold/scaffold_widget.dart';
import 'bottom_navigator_widget.dart';

class NavigatorRouterWidget extends StatefulWidget {
  final List<GetPage> pages;

  final RxInt selectedIndex;
  final Function(int) changeTab;
  final List<BottomItem> bottomItems;

  const NavigatorRouterWidget({
    super.key,
    required this.pages,
    required this.selectedIndex,
    required this.changeTab,
    required this.bottomItems,
  });

  @override
  State<NavigatorRouterWidget> createState() => _NavigatorRouterWidgetState();
}

class _NavigatorRouterWidgetState extends State<NavigatorRouterWidget> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        var navigatorState = Get.nestedKey(widget.selectedIndex.value);
        if (navigatorState?.currentState?.canPop() ?? false) {
          navigatorState!.currentState?.pop();
        }
      },
      child: ScaffoldWidget(
        canPop: false,
        body: Obx(
          () => IndexedStack(
            index: widget.selectedIndex.value,
            children: widget.pages.asMap().entries.map((entry) {
              return _nestedNavigator(entry.key, entry.value);
            }).toList(),
          ),
        ),
        bottomWidget: BottomNavigatorWidget(
          selectedIndex: widget.selectedIndex,
          changeTab: widget.changeTab,
          items: widget.bottomItems,
        ),
      ),
    );
  }

  Widget _nestedNavigator(int index, GetPage page) {
    return Navigator(
      key: Get.nestedKey(index),
      onGenerateRoute: (RouteSettings settings) {
        return page.children.map((child) {
          return GetPageRoute(
            settings: settings,
            page: child.page,
            popGesture: false,
            routeName: child.name,
            binding: child.binding,
            bindings: child.bindings,
            parameter: child.parameters,
            middlewares: child.middlewares,
            transition:
                kIsWeb ? Transition.noTransition : Transition.rightToLeft,
          );
        }).firstWhere(
          (page) => page.routeName == settings.name,
          orElse: () => GetPageRoute(
            settings: settings,
            page: page.page,
            popGesture: false,
            routeName: page.name,
            binding: page.binding,
            bindings: page.bindings,
            parameter: page.parameters,
            middlewares: page.middlewares,
            transition:
                kIsWeb ? Transition.noTransition : Transition.rightToLeft,
          ),
        );
      },
    );
  }
}
