import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter/material.dart';

class ScaffoldWidget extends StatefulWidget {
  final int? nestedId;
  final BaseController? controller;
  final bool canPop;
  final bool showBackButtonOnWeb;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool hideAppBar;
  final String? title;
  final Widget? titleWidget;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;
  final bool showNotificationsIcon;
  final Color? appBarBackgroundColor;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final List<PopupMenuItem>? appBarPopUpMenuItems;
  final bool runPopGesture;

  ScaffoldWidget({
    super.key,
    this.nestedId,
    required this.controller,
    this.canPop = true,
    this.showBackButtonOnWeb = true,
    this.drawer,
    this.endDrawer,
    this.hideAppBar = false,
    this.title,
    this.titleWidget,
    this.body,
    this.floatingActionButton,
    this.bottomWidget,
    this.showNotificationsIcon = false,
    this.appBarBackgroundColor,
    this.appBarLeading,
    this.appBarActions,
    this.appBarPopUpMenuItems,
    this.runPopGesture = true,
  }) {
    if (title != null) {
      assert(titleWidget == null, 'titleWidget must not be null');
    }
    if (titleWidget != null) assert(title == null, 'title must not be null');
  }

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  bool _alreadyRemoveRouteStack = false;

  void _onPopInvokedWithResult(bool didPop, result, BuildContext context) {
    if (!widget.runPopGesture) return;

    if (didPop) {
      if (widget.controller != null && !_alreadyRemoveRouteStack) {
        // HapticFeedback.lightImpact();
        // return widget.controller!.backPage();
      }
      return;
    }

    final currentNavigationIndex = BaseController.navigatorIndex.value;

    if (Platform.isWeb) {
      if (widget.controller == null) return;
      final navigatorState = Get.nestedKey(currentNavigationIndex);
      if (navigatorState?.currentState?.canPop() ?? false) {
        return navigatorState!.currentState?.pop();
      }
      widget.controller?.backPage();
      return;
    }

    if (Platform.isAndroid) {
      if (widget.controller == null) {
        final navigatorState = Get.nestedKey(currentNavigationIndex);
        if (navigatorState?.currentState?.canPop() ?? false) {
          HapticFeedback.lightImpact();
          _alreadyRemoveRouteStack = false;
          return navigatorState!.currentState?.pop();
        }
      }
      if (Navigator.canPop(context) && widget.canPop) {
        if (widget.controller != null) {
          HapticFeedback.lightImpact();
          _alreadyRemoveRouteStack = true;
          widget.controller!.backPage();
        }
      } else {
        HapticFeedback.lightImpact();
        SystemNavigator.pop(animated: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Obx(() {
          return BlurEffectWidget(
            enabled: AppSecurityManager.enableBlur.value,
            ignorePointer: AppSecurityManager.enableBlur.value,
            child: PopScope(
              canPop: widget.canPop && Platform.appleDevice,
              onPopInvokedWithResult: (didPop, result) {
                return _onPopInvokedWithResult(didPop, result, context);
              },
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Material(
                  elevation: 1.0,
                  child: Scaffold(
                    drawer: widget.drawer,
                    endDrawer: widget.endDrawer,
                    appBar: widget.title != null || widget.titleWidget != null
                        ? AppBarWidget(
                            controller: widget.controller,
                            title: widget.title,
                            titleWidget: widget.titleWidget,
                            canPop: widget.canPop,
                            showBackButtonOnWeb: widget.showBackButtonOnWeb,
                            hasDrawer: widget.drawer != null,
                            showNotificationsIcon: widget.showNotificationsIcon,
                            backgroundColor: widget.appBarBackgroundColor,
                            leading: widget.appBarLeading,
                            appBarActions: widget.appBarActions,
                            popupMenuItems: widget.appBarPopUpMenuItems,
                          )
                        : widget.runPopGesture && widget.hideAppBar == false
                        ? AppBar(toolbarHeight: 0)
                        : null,
                    body: widget.body != null
                        ? SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: widget.body,
                          )
                        : null,
                    floatingActionButton: widget.floatingActionButton,
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.endFloat,
                    bottomNavigationBar: widget.bottomWidget,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
