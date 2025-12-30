import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

abstract class Captcha {
  static Future<bool?> show(BuildContext context) async {
    //if (true || Platform.isMobile) {
    return BottomSheetWidget.show(
      context: context,
      child: CaptchaWidget(
        onSuccess: () {
          Navigator.pop(context, true);
        },
      ),
    );
    // } else {
    //   return DialogWidget.showCaptcha(context);
    // }
  }
}
