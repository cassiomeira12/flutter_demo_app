import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';

class MainCardWidget extends AppView<WebController> {
  const MainCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(30),
        vertical: ResponsiveSizeHelper.height(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            'welcome_app'.tr.replaceFirst(
              '{appName}',
              controller.environment.appName,
            ),
            textAlign: TextAlign.center,
            style: AppTextStyle.title(context),
          ),
          const SpacerWidget(),
          Container(
            width: ResponsiveSizeHelper.width(100),
            height: ResponsiveSizeHelper.width(100),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(AppAssets.logo)),
            ),
          ),
        ],
      ),
    );
  }
}
