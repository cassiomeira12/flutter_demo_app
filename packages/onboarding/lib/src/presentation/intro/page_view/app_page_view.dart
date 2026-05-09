import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppPageView extends StatefulWidget {
  final String appName;

  const AppPageView({
    super.key,
    required this.appName,
  });

  @override
  State<AppPageView> createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 9,
              child: Container(
                padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
                color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: ResponsiveSizeHelper.width(150),
                          height: ResponsiveSizeHelper.width(150),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(AppAssets.logo),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
                child: Column(
                  children: [
                    TextWidget(
                      widget.appName,
                      style: AppTextStyle.subtitle(
                        context,
                        fontSize: TextSize.font_20,
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    Flexible(
                      child: TextWidget(
                        'body_intro_app'.tr,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.message(
                          context,
                          fontSize: TextSize.font_14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
