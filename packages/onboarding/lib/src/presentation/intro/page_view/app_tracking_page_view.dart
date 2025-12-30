import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppTrackingPageView extends StatefulWidget {
  final Function(Permission permission) onPermission;

  const AppTrackingPageView({super.key, required this.onPermission});

  @override
  State<AppTrackingPageView> createState() => _AppTrackingPageViewState();
}

class _AppTrackingPageViewState extends State<AppTrackingPageView> {
  @override
  void initState() {
    super.initState();
    widget.onPermission.call(Permission.appTrackingTransparency);
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
              TextWidget(
                'Permitir rastreamento',
                style: AppTextStyle.subtitle(context),
              ),
              const SpacerWidget(height: 2),
              const TextWidget(
                'Autorize o App a acompanhar sua atividade online para uma experiência personalizada.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
