import 'package:design_system/design_system.dart';

class NavigatorItem {
  final String routeName;
  final Map<String, dynamic>? arguments;
  final NavigatorBottom _bottomItem;

  NavigatorItem({
    required this.routeName,
    this.arguments,
    required NavigatorBottom bottomItem,
  }) : _bottomItem = bottomItem.copyWith(
         customKey: bottomItem.customKey ?? routeName,
       );

  NavigatorBottom get bottomItem => _bottomItem;
}

class NavigatorBottom {
  String? customKey;
  final String title;
  final FlutterIcon selectedIcon;
  final FlutterIcon _unselectedIcon;

  FlutterIcon get unselectedIcon => _unselectedIcon;

  NavigatorBottom({
    this.customKey,
    required this.title,
    required this.selectedIcon,
    FlutterIcon? unselectedIcon,
  }) : _unselectedIcon = unselectedIcon ?? selectedIcon;

  NavigatorBottom copyWith({
    String? customKey,
    String? title,
    FlutterIcon? selectedIcon,
    FlutterIcon? unselectedIcon,
  }) {
    return NavigatorBottom(
      customKey: customKey ?? this.customKey,
      title: title ?? this.title,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      unselectedIcon: unselectedIcon ?? this.unselectedIcon,
    );
  }
}
