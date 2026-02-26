import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';

class FeaturesCardWidget extends AppView<WebController> {
  const FeaturesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).dividerColor,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(30),
        vertical: ResponsiveSizeHelper.height(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget('features_web_app'.tr, style: AppTextStyle.title(context)),
          const SpacerWidget(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: ResponsiveSizeHelper.width(20),
            runSpacing: ResponsiveSizeHelper.height(20),
            children: List.generate(4, (index) {
              return Card(
                child: SizedBox(
                  width: ResponsiveSizeHelper.width(200),
                  height: ResponsiveSizeHelper.width(350),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
