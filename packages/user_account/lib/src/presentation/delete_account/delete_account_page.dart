import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'delete_account.dart';

class DeleteAccountPage extends AppView<DeleteAccountController> {
  const DeleteAccountPage({super.key});

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
                        'delete_account_title'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      const SpacerWidget(),
                      ...[
                        'delete_account_reason_1'.tr,
                        'delete_account_reason_2'.tr,
                        'delete_account_reason_3'.tr,
                        'delete_account_reason_4'.tr,
                      ].asMap().entries.map((entry) {
                        return Obx(() {
                          return CheckboxTitleWidget(
                            customKey: Key(
                              'delete_account_reason_${entry.key + 1}',
                            ),
                            text: entry.value,
                            initialValue: entry.value == controller.reason,
                            onChanged: (value) {
                              if (value) {
                                controller.setReason(entry.value);
                              } else {
                                controller.setReason(null);
                              }
                            },
                          );
                        });
                      }),
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
          height: kToolbarHeight,
          child: Center(
            child: Obx(() {
              return PrimaryButton(
                key: const Key('finish_my_account_button_key'),
                text: 'finish_my_account'.tr,
                expandWidth: true,
                backgroundColor: AppColors.statusError,
                onPressed: controller.reason == null
                    ? null
                    : () async {
                        final loginValidation =
                            await PasswordValidationBottomSheet.show(context);
                        if (loginValidation == true) {
                          controller.openNextPage();
                        }
                      },
              );
            }),
          ),
        ),
      ),
    );
  }
}
