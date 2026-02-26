import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';

class AboutCardWidget extends AppView<WebController> {
  const AboutCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.disabledColorDark,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(30),
        vertical: ResponsiveSizeHelper.height(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            'about_web_app'.tr,
            style: AppTextStyle.title(context, color: AppColors.white),
          ),
          const SpacerWidget(),
          SelectableText(
            'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. ',
            textAlign: TextAlign.center,
            style: AppTextStyle.subtitle(context, color: AppColors.white),
          ),
          const SpacerWidget(),
          SelectableText(
            'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',
            textAlign: TextAlign.center,
            style: AppTextStyle.subtitle(context, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
