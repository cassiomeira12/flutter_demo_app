import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ClearCacheBottomSheetWidget extends StatelessWidget {
  final Future<void> Function() onClearCache;

  const ClearCacheBottomSheetWidget({super.key, required this.onClearCache});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget('want_to_clear_cache'.tr),
        const SpacerWidget(),
        TextWidget(
          'Todos os dados de cache do aplicativo serão apagas, você será deslogado e poderá fazer login novamente.'
              .tr,
          textAlign: TextAlign.center,
        ),
        const SpacerWidget(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureButton(
              text: 'clear_cache'.tr,
              size: ButtonSize.medium,
              onPressed: onClearCache,
            ),
            SecondaryButton(
              text: 'back'.tr,
              size: ButtonSize.medium,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SpacerWidget(),
      ],
    );
  }
}
