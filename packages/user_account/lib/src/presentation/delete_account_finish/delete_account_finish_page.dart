import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:user_account/src/presentation/delete_account_finish/delete_account_finish.dart';

class DeleteAccountFinishPage extends AppView<DeleteAccountFinishController> {
  const DeleteAccountFinishPage({super.key});

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
                        'delete_account_finish_title'.tr,
                        style: AppTextStyle.subtitle(context, bold: true),
                      ),
                      const SpacerWidget(),
                      TextWidget(
                        'delete_account_finish_feature_1'.tr,
                        style: AppTextStyle.message(context, bold: true),
                      ),
                      TextWidget(
                        'delete_account_finish_feature_2'.tr,
                        style: AppTextStyle.message(context, bold: true),
                      ),
                      TextWidget(
                        'delete_account_finish_feature_3'.tr,
                        style: AppTextStyle.message(context, bold: true),
                      ),
                      const SpacerWidget(),
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
            child: PrimaryButton(
              text: 'finish_my_account'.tr,
              expandWidth: true,
              backgroundColor: AppColors.statusError,
              onPressed: controller.openNextPage,
            ),
          ),
        ),
      ),
    );
  }
}
