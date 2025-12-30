import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PermissionRequestWidget extends StatefulWidget {
  final Permission permission;

  const PermissionRequestWidget({super.key, required this.permission});

  @override
  State<PermissionRequestWidget> createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget> {
  final controller = PermissionRequestController();

  RequestPermissionUseCase requestPermissionUseCase = AppBinding.find();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '',
      controller: controller,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeHelper.width(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterIcon(permissionIcon, size: IconSize.large),
            const SpacerWidget(),
            TextWidget(
              '${widget.permission}_title'.toLowerCase().tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.title(context),
            ),
            const SpacerWidget(),
            TextWidget(
              '${widget.permission}_message'.toLowerCase().tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.subtitle(context),
            ),
            const SpacerWidget(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSizeHelper.width(30),
              ),
              child: FutureButton(
                text: 'allow'.tr,
                expandWidth: true,
                onPressed: () async {
                  final result = await requestPermissionUseCase.call(
                    widget.permission,
                    openSettings: true,
                  );
                  controller.backPage(result: result);
                },
              ),
            ),
            const SpacerWidget(height: 2),
            SecondaryButton(
              text: 'allow_later'.tr,
              onPressed: controller.backPage,
            ),
          ],
        ),
      ),
    );
  }

  IconData get permissionIcon {
    switch (widget.permission) {
      case Permission.location:
        return FontAwesome.location_pin_lock_solid;
      case Permission.notification:
        return FontAwesome.bell;
      case Permission.camera:
        return FontAwesome.camera_solid;
      default:
        return FontAwesome.lock_solid;
    }
  }
}

class PermissionRequestController extends BaseController {
  @override
  String get pageRouteNamed {
    return '/${runtimeType.toString().replaceAll('Controller', 'Widget')}';
  }

  @override
  void backPage({
    dynamic result,
    bool ignoreId = true,
    bool? onlyPopStackRouter,
  }) {
    super.backPage(result: result);
  }
}
