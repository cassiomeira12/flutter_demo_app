import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BaseController? controller;
  final String? title;
  final Widget? titleWidget;
  final bool canPop;
  final bool showBackButtonOnWeb;
  final Color? backgroundColor;
  final Widget? leading;
  final bool hasDrawer;
  final bool showNotificationsIcon;
  final List<Widget>? appBarActions;
  final List<PopupMenuItem>? popupMenuItems;

  const AppBarWidget({
    super.key,
    this.controller,
    required this.title,
    required this.titleWidget,
    this.canPop = true,
    this.showBackButtonOnWeb = false,
    this.backgroundColor,
    this.leading,
    this.hasDrawer = false,
    this.showNotificationsIcon = false,
    this.appBarActions,
    this.popupMenuItems,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: ResponsiveSizeHelper.appBarHeight,
      child: AppBar(
        centerTitle: Platform.isWeb,
        title: title != null
            ? TextWidget(
                title!,
                style: AppTextStyle.subtitle(
                  context,
                  color: theme.appBarTheme.titleTextStyle?.color,
                ),
              )
            : titleWidget,
        leadingWidth: canPop && Navigator.canPop(context) ? null : 0,
        backgroundColor: backgroundColor,
        leading: leading ?? _leadingWidget(context),
        actions: [
          // if (showNotificationsIcon &&
          //     AppBinding.hasInstance<NotificationsStore>())
          //   Obx(() {
          //     return NotificationBadgesWidget(
          //       key: const Key('notifications_bell_icon_key'),
          //       count: AppBinding.find<NotificationsStore>()
          //           .countUnreadNotifications
          //           .value,
          //       onPressed: controller?.openNotifications,
          //     );
          //   }),
          ...appBarActions ?? [],
          if (popupMenuItems != null)
            PopupMenuButton(
              key: const Key('popup_menu_key'),
              icon: FlutterIcon(
                Icons.more_vert,
                size: IconSize.medium,
                color: theme.popupMenuTheme.iconColor,
              ),
              itemBuilder: (context) => popupMenuItems!,
              onOpened: () => HapticFeedback.lightImpact(),
              onSelected: (_) => HapticFeedback.lightImpact(),
              onCanceled: () => HapticFeedback.lightImpact(),
            ),
        ],
      ),
    );
  }

  Widget? _leadingWidget(BuildContext context) {
    if (hasDrawer) return null;
    if (canPop) {
      if (!showBackButtonOnWeb || !Navigator.canPop(context)) {
        return null;
      }
    } else {
      return const SizedBox.shrink();
    }
    return null;
  }

  // Widget _backButton(BuildContext context) {
  //   return BackButton(
  //     onPressed: () {
  //       controller?.backPage();
  //       if (controller == null) {
  //         Navigator.maybePop(context);
  //       }
  //     },
  //   );
  // }
}
