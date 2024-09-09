import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../design_system.dart';

class ScaffoldWidget extends StatefulWidget {
  final BaseController? controller;
  final bool canPop;
  final bool showBackButtonOnWeb;
  final String? title;
  final Widget? titleWidget;
  final Widget? body;
  final Widget? bottomWidget;

  ScaffoldWidget({
    super.key,
    this.controller,
    this.canPop = true,
    this.showBackButtonOnWeb = false,
    this.title,
    this.titleWidget,
    this.body,
    this.bottomWidget,
  }) {
    if (title != null) assert(titleWidget != null);
    if (titleWidget != null) assert(title != null);
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
        if (widget.canPop && !didPop && ModalRoute.of(context)!.canPop) {
          widget.controller?.backPage();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: widget.title != null,
          title: widget.title != null
              ? TextWidget(widget.title!)
              : widget.titleWidget,
          leading: kIsWeb && widget.showBackButtonOnWeb
              ? ModalRoute.of(context)!.canPop
                  ? BackButton()
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ),
        body: widget.body,
        bottomNavigationBar: widget.bottomWidget != null
            ? SizedBox(
                height: kToolbarHeight,
                child: widget.bottomWidget,
              )
            : null,
      ),
    );
  }
}
