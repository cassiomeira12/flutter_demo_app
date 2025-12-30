import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class DrawerWebWidget extends StatelessWidget {
  final List<Widget> children;

  const DrawerWebWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Drawer(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                spacing: ResponsiveSizeHelper.height(1),
                children: [...children],
              );
            },
          ),
        ),
      ),
    );
  }
}
