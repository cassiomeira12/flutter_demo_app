import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PushNotificationPageView extends StatefulWidget {
  final Function(Permission permission) onPermission;

  const PushNotificationPageView({super.key, required this.onPermission});

  @override
  State<PushNotificationPageView> createState() =>
      _PushNotificationPageViewState();
}

class _PushNotificationPageViewState extends State<PushNotificationPageView> {
  @override
  void initState() {
    super.initState();
    widget.onPermission.call(Permission.notification);
  }

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
                child: Center(
                  child: Icon(
                    Icons.notifications,
                    size: ResponsiveSizeHelper.width(100),
                    color: Colors.white,
                  ),
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
                      'title_intro_notification'.tr,
                      style: AppTextStyle.subtitle(
                        context,
                        fontSize: TextSize.font_20,
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    Flexible(
                      child: TextWidget(
                        'body_intro_notification'.tr,
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
