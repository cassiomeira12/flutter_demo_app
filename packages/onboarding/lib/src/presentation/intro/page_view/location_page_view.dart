import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LocationPageView extends StatefulWidget {
  final Function(Permission permission) onPermission;

  const LocationPageView({super.key, required this.onPermission});

  @override
  State<LocationPageView> createState() => _LocationPageViewState();
}

class _LocationPageViewState extends State<LocationPageView> {
  @override
  void initState() {
    super.initState();
    widget.onPermission.call(Permission.location);
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
              TextWidget('Localização', style: AppTextStyle.subtitle(context)),
              const SpacerWidget(height: 2),
              const TextWidget(
                'Autorize o App a acompanhar sua localização para uma experiência personalizada.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
