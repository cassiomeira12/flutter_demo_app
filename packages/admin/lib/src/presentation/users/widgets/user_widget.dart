import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UserWidget extends StatelessWidget {
  final UserEntity user;
  final Function()? onTap;
  final List<String>? popMenuItems;
  final Function(String menu)? onPopMenuTap;

  const UserWidget({
    super.key,
    required this.user,
    required this.onTap,
    required this.popMenuItems,
    required this.onPopMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: ResponsiveSizeHelper.width(40),
        height: ResponsiveSizeHelper.width(40),
        child: ImageWidget(imageUrl: user.avatarUrl),
      ),
      title: TextWidget(
        user.name,
        // style: fontField(context, bold: true),
      ),
      subtitle: TextWidget(
        user.email,
        // style: fontField(context, size: 15),
      ),
      trailing: popMenuItems == null
          ? null
          : PopupMenuButton(
              icon: const FlutterIcon(Icons.more_vert),
              itemBuilder: (context) {
                return popMenuItems!.map((item) {
                  return PopupMenuItem(
                    value: item,
                    child: TextWidget(item.tr),
                    onTap: () => onPopMenuTap?.call(item),
                  );
                }).toList();
              },
            ),
    );
  }
}
