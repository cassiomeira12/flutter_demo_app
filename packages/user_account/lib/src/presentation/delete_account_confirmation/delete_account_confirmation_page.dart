import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/delete_account_confirmation/delete_account_confirmation.dart';

class DeleteAccountConfirmationPage
    extends AppView<DeleteAccountConfirmationController> {
  const DeleteAccountConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'delete_my_account'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: ResponsiveSizeHelper.maxWidth,
                  ),
                  child: Column(
                    spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        'warning'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      TextWidget(
                        'delete_account_information_title'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      const SpacerWidget(),
                      TextWidget(
                        'delete_account_information_1'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      TextWidget(
                        'delete_account_information_2'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      TextWidget(
                        'delete_account_information_3'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      const SpacerWidget(),
                      TextWidget(
                        'delete_account_information_info'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomWidget: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveSizeHelper.spacingDefaultWidth,
          right: ResponsiveSizeHelper.spacingDefaultWidth,
          bottom: ResponsiveSizeHelper.navigationBarHeight,
        ),
        child: SizedBox(
          height: kToolbarHeight * 2,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureButton(
                  text: 'finish_my_account'.tr,
                  expandWidth: true,
                  backgroundColor: AppColors.statusError,
                  onPressed: () async {
                    try {
                      final captchaAccepted = await Captcha.show(context);
                      if (captchaAccepted != true) {
                        return;
                      }
                      if (!context.mounted) return;
                      final loginValidation =
                          await PasswordValidationBottomSheet.show(context);
                      if (loginValidation != true) {
                        return;
                      }
                      await controller.deleteAccount();
                    } on BaseException catch (error) {
                      if (!context.mounted) return;
                      DialogWidget.showError(
                        context,
                        message: error.message.tr,
                      );
                    }
                  },
                ),
                const SpacerWidget(),
                SecondaryButton(
                  text: 'not_delete_my_account'.tr,
                  expandWidth: true,
                  onPressed: controller.closeDeleteAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
