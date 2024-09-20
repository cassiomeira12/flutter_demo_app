import 'package:flutter_demo_app/design_system/design_system.dart';
import 'package:get/get.dart';

class BottomSheetWidget {
  static Future<dynamic> show({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
    Function? finishCallBackFunction,
    AppColor? backgroundColor,
    bool isDismissible = true,
    bool showCloseButton = true,
  }) async {
    return await Get.bottomSheet(
      SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: contentPadding ??
                EdgeInsets.all(ResponsiveSizeHelper.width(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCloseButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: FlutterIcon(
                          Icons.close,
                          key: const Key('close_button'),
                          size: IconSize.medium,
                          // color: Theme.of(context).indicatorColor,
                        ),
                        onTap: () => Get.close(1),
                      ),
                    ],
                  ),
                // SizedBox(height: Constraints.height * .01),
                child,
              ],
            ),
          ),
        ),
      ),
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
    ).whenComplete(() => finishCallBackFunction?.call());
  }
}
