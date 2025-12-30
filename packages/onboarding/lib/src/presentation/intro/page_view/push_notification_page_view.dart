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
      body: Container(
        padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget('Notificações', style: AppTextStyle.subtitle(context)),
              const SpacerWidget(height: 2),
              const TextWidget(
                'Ativa as notificações e fique por dentro das notícias que realmente importam',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
