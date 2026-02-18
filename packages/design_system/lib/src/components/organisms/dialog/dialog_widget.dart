import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

abstract class DialogWidget {
  static Widget _baseDialog(
    BuildContext context, {
    bool showCloseButton = true,
    required List<Widget> children,
  }) {
    return Center(
      key: const Key('dialog_widget_key'),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: ResponsiveSizeHelper.maxWidth,
        ),
        child: Card(
          elevation: 4,
          color: Theme.of(context).highlightColor,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showCloseButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButtonWidget(
                        key: const Key('dialog_close_icon_key'),
                        icon: FlutterIcon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showError(
    BuildContext context, {
    required String message,
  }) async {
    if (!context.mounted) return;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _baseDialog(
          context,
          showCloseButton: false,
          children: [
            const SpacerWidget(height: 3),
            FlutterIcon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
              size: IconSize.large,
            ),
            const SpacerWidget(height: 2),
            TextWidget(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.message(context, fontSize: TextSize.font_14),
            ),
            const SpacerWidget(height: 2),
            PrimaryButton(
              key: const Key('dialog_ok_button_key'),
              text: 'ok'.tr,
              size: ButtonSize.medium,
              onPressed: () => Navigator.pop(context),
            ),
            const SpacerWidget(),
          ],
        );
      },
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    if (!context.mounted) return;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _baseDialog(
          context,
          children: [
            TextWidget(title, textAlign: TextAlign.center),
            const SpacerWidget(),
            TextWidget(message, textAlign: TextAlign.center),
            const SpacerWidget(height: 2),
            PrimaryButton(
              key: const Key('dialog_ok_button_key'),
              text: 'ok'.tr,
              size: ButtonSize.medium,
              onPressed: () => Navigator.pop(context),
            ),
            const SpacerWidget(),
          ],
        );
      },
    );
  }

  static Future<bool?> showChoice(
    BuildContext context, {
    required String title,
    required String message,
    String okButton = 'ok',
    String cancelButton = 'cancel',
  }) async {
    if (!context.mounted) return null;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _baseDialog(
          context,
          children: [
            TextWidget(
              title,
              style: AppTextStyle.subtitle(context),
              textAlign: TextAlign.center,
            ),
            const SpacerWidget(),
            TextWidget(
              message,
              style: AppTextStyle.message(context, bold: true),
              textAlign: TextAlign.center,
            ),
            const SpacerWidget(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SecondaryButton(
                  key: const Key('dialog_cancel_button_key'),
                  text: cancelButton.tr,
                  size: ButtonSize.medium,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                PrimaryButton(
                  key: const Key('dialog_ok_button_key'),
                  text: okButton.tr,
                  size: ButtonSize.medium,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
            const SpacerWidget(),
          ],
        );
      },
    );
  }

  static Future<bool?> showCaptcha(BuildContext context) async {
    if (!context.mounted) return false;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _baseDialog(
          context,
          children: [
            CaptchaWidget(
              onSuccess: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showModal(
    BuildContext context, {
    required Widget child,
  }) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          key: const Key('dialog_widget_key'),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveSizeHelper.maxWidth,
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(padding: const EdgeInsets.all(15), child: child),
            ),
          ),
        );
      },
    );
  }
}
