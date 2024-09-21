import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../colors/app_color.dart';
import '../../helpers/responsive_size_helper.dart';
import '../../text/text_style.dart';
import '../../text/text_widget.dart';

class BottomNavigatorWidget extends StatefulWidget {
  final RxInt selectedIndex;
  final Function(int) changeTab;
  final List<BottomItem> items;

  const BottomNavigatorWidget({
    super.key,
    required this.selectedIndex,
    required this.changeTab,
    required this.items,
  });

  @override
  State<BottomNavigatorWidget> createState() => _BottomNavigatorWidgetState();
}

class _BottomNavigatorWidgetState extends State<BottomNavigatorWidget> {
  @override
  Widget build(BuildContext context) {
    final double bottomPadding =
        ResponsiveSizeHelper.mediaQuery.viewPadding.bottom;
    return Container(
      color: Theme.of(context).cardColor,
      height: kBottomNavigationBarHeight + bottomPadding + 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items.asMap().entries.map((entry) {
          return Obx(
            () => bottomBarItem(
              index: entry.key,
              item: entry.value,
              onTap: widget.changeTab,
              isSelected: entry.key == widget.selectedIndex.value,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget bottomBarItem({
    required int index,
    required BottomItem item,
    required Function(int) onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        width: ResponsiveSizeHelper.width(100),
        decoration: BoxDecoration(
          // color: Colors.red,
          border: Border(
            top: BorderSide(
              width: 2,
              color: isSelected
                  ? Theme.of(context).iconTheme.color!
                  : AppColors.transparent,
            ),
          ),
        ),
        child: Expanded(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isSelected ? item.selectedIcon : item.unselectedIcon,
                TextWidget(
                  item.title,
                  style: AppTextStyle.field(
                    context,
                    bold: isSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomItem {
  final String title;
  final Widget selectedIcon;
  final Widget unselectedIcon;

  BottomItem({
    required this.title,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}
