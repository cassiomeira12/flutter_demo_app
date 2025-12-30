import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'splash.dart';

class SplashPage extends AppView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, _) {
        return ScaffoldWidget(
          controller: controller,
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Center(
                child: Container(
                  width: ResponsiveSizeHelper.width(150),
                  height: ResponsiveSizeHelper.width(150),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(AppAssets.logo)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveSizeHelper.height(
                    ResponsiveSizeHelper.maxHeight * .5,
                  ),
                ),
                child: const Center(child: CircularLoadingWidget()),
              ),
            ],
          ),
        );
      },
    );
  }
}
