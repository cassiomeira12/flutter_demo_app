import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class BottomNavigatorWidget extends StatefulWidget {
  final RxnInt selectedIndex;
  final Function(int index) onTap;
  final Function(int index, String? key) changeTab;
  final List<NavigatorBottom> items;

  const BottomNavigatorWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.changeTab,
    required this.items,
  });

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget> {
  bool showBottomNavigator = true;

  int? _lastIndexSelected;
  late Map<int, RxBool> _observableIndex;
  StreamSubscription? _selectedIndexStream;

  @override
  void initState() {
    super.initState();
    _lastIndexSelected = widget.selectedIndex.value;
    _observableIndex = widget.items.asMap().map((index, item) {
      return MapEntry(index, RxBool(index == widget.selectedIndex.value));
    });
    _selectedIndexStream = widget.selectedIndex.listen((index) {
      if (_lastIndexSelected != null) {
        _observableIndex[_lastIndexSelected]!.value = false;
      }
      _observableIndex[index]!.value = true;
      _lastIndexSelected = index;
    });
  }

  @override
  void dispose() {
    _selectedIndexStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KeyboardVisibiltyWidget(
      onKeyboardStateChange: (state) {
        setState(() {
          showBottomNavigator = state == KeyboardVisibilityState.hiden;
        });
      },
      child: showBottomNavigator
          ? Container(
              height: ResponsiveSizeHelper.navigationBarHeight,
              decoration: BoxDecoration(
                color: theme.bottomNavigationBarTheme.backgroundColor,
                border: Border(
                  top: BorderSide(width: .2, color: theme.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.items.asMap().entries.map((entry) {
                  return Obx(
                    () => Flexible(
                      child: bottomBarItem(
                        context,
                        index: entry.key,
                        item: entry.value,
                        onTap: widget.onTap,
                        changeTab: widget.changeTab,
                        isSelected: _observableIndex[entry.key]!.value,
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget bottomBarItem(
    BuildContext context, {
    required int index,
    required NavigatorBottom item,
    required Function(int index) onTap,
    required void Function(int index, String? key) changeTab,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final Color color = isSelected
        ? theme.bottomNavigationBarTheme.selectedItemColor ?? theme.primaryColor
        : AppColors.transparent;
    final FlutterIcon icon = isSelected
        ? item.selectedIcon.copyWith(color: color)
        : item.unselectedIcon;
    return SafeArea(
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        // color: color, // theme.bottomNavigationBarTheme.backgroundColor,
        child: InkWell(
          key: item.customKey == null ? null : Key(item.customKey!),
          onTap: () {
            onTap(index);
            changeTab(index, item.customKey);
            HapticFeedback.lightImpact();
          },
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Container(
            width: ResponsiveSizeHelper.width(100),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 2, color: color)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  Flexible(
                    child: TextWidget(
                      item.title.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.field(
                        context,
                        bold: isSelected,
                        fontSize: TextSize.font_10,
                        color: isSelected
                            ? theme.bottomNavigationBarTheme.selectedItemColor
                            : theme
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
