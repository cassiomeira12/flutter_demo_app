import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../web.dart';

class DownloadCardWidget extends AppView<WebController> {
  const DownloadCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(30),
        vertical: ResponsiveSizeHelper.height(100),
      ),
      child: Column(
        children: [
          TextWidget('download_app'.tr, style: AppTextStyle.title(context)),
          const SpacerWidget(height: 2),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: ResponsiveSizeHelper.width(20),
            runSpacing: ResponsiveSizeHelper.height(20),
            children: [
              InkWell(
                key: const Key('download_apple_store_key'),
                onTap: controller.downloadAppleApp,
                child: Image.asset(AppAssets.appStore),
              ),
              InkWell(
                key: const Key('download_google_store_key'),
                onTap: controller.downloadAndroidApp,
                child: Image.asset(AppAssets.playStore),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
