import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:user_account/src/presentation/delete_account_finished/delete_account_finished.dart';

class DeleteAccountFinishedPage
    extends AppView<DeleteAccountFinishedController> {
  const DeleteAccountFinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '',
      canPop: false,
      controller: controller,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveSizeHelper.maxWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: ResponsiveSizeHelper.spacingDefaultHeight,
              children: [
                const FlutterIcon(
                  Icons.check_circle,
                  size: IconSize.large,
                  color: AppColors.statusSuccess,
                ),
                TextWidget(
                  'delete_account_success'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.subtitle(context, bold: true),
                ),
                const SpacerWidget(),
                TextWidget(
                  'delete_account_success_message'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.message(context, bold: true),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomWidget: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveSizeHelper.spacingDefaultWidth,
          right: ResponsiveSizeHelper.spacingDefaultWidth,
          bottom: ResponsiveSizeHelper.navigationBarHeight,
        ),
        child: SizedBox(
          height: kToolbarHeight,
          child: Center(
            child: SecondaryButton(
              text: 'logout'.tr,
              expandWidth: true,
              onPressed: controller.close,
            ),
          ),
        ),
      ),
    );
  }
}
