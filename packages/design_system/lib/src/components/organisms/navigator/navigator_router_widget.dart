import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class NavigatorRouterWidget extends StatefulWidget {
  final int initialIndex;
  final RxnInt selectedIndex;
  final List<AppRouterPage> pages;
  final Function(int index, String? key) changeTab;
  final List<NavigatorBottom>? bottomItems;

  const NavigatorRouterWidget({
    super.key,
    required this.initialIndex,
    required this.selectedIndex,
    required this.pages,
    required this.changeTab,
    this.bottomItems,
  });

  @override
  State<NavigatorRouterWidget> createState() => _NavigatorRouterWidgetState();
}

class _NavigatorRouterWidgetState extends State<NavigatorRouterWidget> {
  final Map<int, Widget> _loadedWidgets = {};

  int? _lastSelectedIndex;
  StreamSubscription? indexChangeStream;

  @override
  void initState() {
    super.initState();
    List.generate(widget.pages.length, (_) {
      _nestedNavigatorList.add(const SizedBox.shrink());
    });
    indexChangeStream = widget.selectedIndex.listen(_updateNavigationIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BaseController.navigatorIndex.value = widget.initialIndex;
    });
    final navigatorRoute = AppRoutes.routes[Get.currentRoute];
    if (navigatorRoute != null) {
      AppRoutes.routes[Get.currentRoute] = navigatorRoute.copyWith(
        navigator: true,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    indexChangeStream?.cancel();
    BaseController.navigatorIndex.value = null;
    AppRoutes.routes.values.where((route) => route.navigator).forEach((route) {
      AppRoutes.routes[route.name] = route.copyWith(navigator: false);
    });
  }

  void _updateNavigationIndex(int? index) {
    if (index != null) {
      if (_nestedNavigatorList[index] is SizedBox) {
        _nestedNavigatorList[index] = _nestedNavigator(
          index,
          widget.pages[index],
        );
      }
    }
    if (index != _lastSelectedIndex) {
      if (_lastSelectedIndex != null &&
          _loadedWidgets[_lastSelectedIndex] != null) {
        _onChangeIndex(_lastSelectedIndex!, false);
      }
      if (index != null && _loadedWidgets[index] != null) {
        _onChangeIndex(index, true);
      }
      _lastSelectedIndex = index;
    }
  }

  void _onChangeIndex(int index, bool isCurrentPage) {
    try {
      if (_loadedWidgets[index] is NavigatorIndexListenerCallback) {
        final page = _loadedWidgets[index]! as NavigatorIndexListenerCallback;
        page.onChangeIndex(isCurrentPage);
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  void _onTapCurrentIndex() {
    final currentIndex = widget.selectedIndex.value;
    if (currentIndex == null) return;
    try {
      if (_loadedWidgets[currentIndex] is TapCurrentIndexCallback) {
        final page = _loadedWidgets[currentIndex]! as TapCurrentIndexCallback;
        page.onTap();
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  final RxList<Widget> _nestedNavigatorList = RxList.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: null,
      canPop: Platform.appleDevice,
      runPopGesture: false,
      body: Obx(
        () => IndexedStack(
          index: widget.selectedIndex.value,
          children: _nestedNavigatorList,
        ),
      ),
      bottomWidget: widget.bottomItems != null
          ? BottomNavigatorWidget(
              selectedIndex: widget.selectedIndex,
              onTap: (index) {
                if (index == widget.selectedIndex.value) {
                  _onTapCurrentIndex();
                }
              },
              changeTab: widget.changeTab,
              items: widget.bottomItems!,
            )
          : null,
    );
  }

  Widget _nestedNavigator(int index, AppRouterPage page) {
    return Navigator(
      key: Get.nestedKey(index),
      observers: [
        GetObserver(null, AppNavigator.nestedRouting[index] = Routing()),
        SentryNavigatorObserver(),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return page.children
            .map((child) {
              return GetPageRoute(
                popGesture:
                    (child.popGesture ?? true) &&
                    (Platform.isWeb || Platform.isIOS),
                settings: settings,
                page: child.page,
                routeName: child.name,
                binding: child.binding,
                bindings: child.bindings,
                parameter: child.parameters,
                middlewares: child.middlewares,
                transition: kIsWeb
                    ? Transition.noTransition
                    : Transition.cupertino,
                transitionDuration: const Duration(milliseconds: 400),
              );
            })
            .where((page) => page.routeName == settings.name)
            .firstOrNull;
      },
      onUnknownRoute: (settings) {
        final GetPageRoute? subRoute = _findSubPageRoute(
          index: index,
          settings: settings,
          routeName: settings.name ?? '',
          defaultPage: page,
          children: List<AppRouterPage>.from(page.children),
        );

        return subRoute ??
            GetPageRoute(
              popGesture:
                  (page.popGesture ?? true) &&
                  (Platform.isWeb || Platform.isIOS),
              settings: settings,
              routeName: AppRouter.unknown.name,
              page: UnknownPage.new,
              binding: UnknownBindings(),
              transition: kIsWeb
                  ? Transition.noTransition
                  : Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 400),
            );
      },
    );
  }

  GetPageRoute? _findSubPageRoute({
    required int index,
    required RouteSettings settings,
    required String routeName,
    required AppRouterPage defaultPage,
    required List<AppRouterPage> children,
  }) {
    if (settings.name == Navigator.defaultRouteName) {
      return GetPageRoute(
        popGesture:
            (defaultPage.popGesture ?? true) &&
            (Platform.isWeb || Platform.isIOS),
        settings: RouteSettings(
          name: defaultPage.name,
          arguments: defaultPage.arguments,
        ),
        page: () => _loadedWidgets[index] = defaultPage.page(),
        routeName: defaultPage.name,
        binding: defaultPage.binding,
        bindings: defaultPage.bindings,
        parameter: defaultPage.parameters,
        middlewares: defaultPage.middlewares,
        transition: kIsWeb ? Transition.noTransition : Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
      );
    }

    if (children.isEmpty) return null;

    AppRouterPage? child = children.firstWhereOrNull((page) {
      return settings.name?.contains(page.name) ?? false;
    });

    child ??= _findChildRoute('/${settings.name?.split('/').last}', children);

    Log.info(
      'Rota para abrir: $routeName \n'
      'Rota mãe: ${defaultPage.name} \n'
      'Child encontrado: ${child?.name}',
    );

    final String concatSubRoute = '${defaultPage.name}${child?.name}';

    final bool foundSubRoute = routeName == concatSubRoute;
    final bool foundChildSubRoute =
        '/${routeName.split('/').last}' == child?.name;

    if (foundSubRoute || foundChildSubRoute || routeName == child?.name) {
      return GetPageRoute(
        popGesture:
            (child?.popGesture ?? true) && (Platform.isWeb || Platform.isIOS),
        settings: settings,
        page: child?.page,
        routeName: child?.name,
        binding: child?.binding,
        bindings: child?.bindings,
        parameter: child?.parameters,
        middlewares: child?.middlewares,
        transition: kIsWeb ? Transition.noTransition : Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
      );
    }

    final String? subRouteName = settings.name?.replaceFirst(
      child?.name ?? '',
      '',
    );

    return _findSubPageRoute(
      index: index,
      settings: settings,
      routeName: subRouteName ?? '',
      defaultPage: defaultPage,
      children: List<AppRouterPage>.from(child?.children ?? []),
    );
  }

  AppRouterPage? _findChildRoute(
    String? routeTofind,
    List<AppRouterPage> children,
  ) {
    if (children.isEmpty) return null;

    for (final child in children) {
      if (routeTofind?.contains(child.name) ?? false) {
        return child;
      }
      final sub = _findChildRoute(
        routeTofind,
        List<AppRouterPage>.from(child.children),
      );
      if (sub != null) {
        return sub;
      }
    }

    return null;
  }
}
