import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationEntity notification;
  final GestureTapCallback onTap;

  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: notification.viewed ? null : Theme.of(context).highlightColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        selected: true,
        leading: Container(
          width: ResponsiveSizeHelper.width(10),
          height: ResponsiveSizeHelper.width(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: notification.viewed
                ? AppColors.transparent
                : AppColors.statusSuccess,
          ),
        ),
        trailing: SizedBox(
          width: ResponsiveSizeHelper.width(40),
          height: ResponsiveSizeHelper.width(40),
          child: notification.imageUrl == null
              ? null
              : ImageWidget(imageUrl: notification.imageUrl!),
        ),
        title: TextWidget(
          notification.title,
          // style: fontField(context, bold: true),
        ),
        subtitle: TextWidget(
          notification.body,
          // style: fontField(context, size: 15),
        ),
        // trailing: FlutterIcon(
        //   BoxIcons.bx_trash,
        //   color: AppColors.statusWarning,
        //   onPressed: () {
        //     onDelete.call(safetyContactEntity.objectId);
        //   },
        // ),
      ),
    );
  }
}
