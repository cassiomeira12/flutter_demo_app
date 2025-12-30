import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class BottomSheetWidget<T> {
  static Future<T> show<T>({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
    Function? finishCallBackFunction,
    Color? backgroundColor,
    bool isDismissible = true,
    bool showCloseButton = true,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveSizeHelper.width(10)),
          topRight: Radius.circular(ResponsiveSizeHelper.width(10)),
        ),
      ),
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: ResponsiveSizeHelper.width(10),
                top: ResponsiveSizeHelper.width(10),
                right: ResponsiveSizeHelper.width(10),
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCloseButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButtonWidget(
                          icon: const FlutterIcon(
                            Icons.close,
                            key: Key('close_button'),
                            size: IconSize.medium,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  SafeArea(child: child),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      HapticFeedback.lightImpact();
      finishCallBackFunction?.call();
    });
  }
}
