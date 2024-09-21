import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../design_system.dart';

class ScaffoldWidget extends StatefulWidget {
  final int? nestedId;
  final BaseController? controller;
  final bool canPop;
  final bool showBackButtonOnWeb;
  final String? title;
  final Widget? titleWidget;
  final Widget? body;
  final Widget? bottomWidget;

  ScaffoldWidget({
    super.key,
    this.nestedId,
    this.controller,
    this.canPop = true,
    this.showBackButtonOnWeb = false,
    this.title,
    this.titleWidget,
    this.body,
    this.bottomWidget,
  }) {
    if (title != null) assert(titleWidget == null);
    if (titleWidget != null) assert(title == null);
  }

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if (widget.canPop && !didPop && Navigator.canPop(context)) {
          if (widget.controller != null) {
            widget.controller!.backPage();
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: widget.title != null
              ? AppBar(
                  centerTitle: widget.title != null,
                  title: widget.title != null
                      ? TextWidget(
                          widget.title!,
                          style: AppTextStyle.subtitle(context),
                        )
                      : widget.titleWidget,
                  leading: kIsWeb
                      ? widget.showBackButtonOnWeb
                          ? Navigator.canPop(context)
                              ? BackButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              : const SizedBox.shrink()
                          : const SizedBox.shrink()
                      : Navigator.canPop(context)
                          ? BackButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          : const SizedBox.shrink(),
                )
              : null,
          body: widget.body != null
              ? Container(
                  width: ResponsiveSizeHelper.mediaQuery.size.width,
                  child: widget.body,
                )
              : null,
          bottomNavigationBar: widget.bottomWidget != null
              ? SizedBox(
                  height: kToolbarHeight,
                  child: widget.bottomWidget,
                )
              : null,
        ),
      ),
    );
  }
}
