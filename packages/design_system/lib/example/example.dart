import 'package:design_system/example/atoms/atoms_example.dart';
import 'package:design_system/example/molecules/molecules_example.dart';
import 'package:design_system/example/organisms/organisms_example.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  '/example': (context) => const ExampleMainPage(),
  ...ExampleAtomsRoutes.values.asMap().map((key, value) {
    return MapEntry(value.route, (context) => value.page);
  }),
  ...ExampleMoleculesRoutes.values.asMap().map((key, value) {
    return MapEntry(value.route, (context) => value.page);
  }),
  ...ExampleOrganismsRoutes.values.asMap().map((key, value) {
    return MapEntry(value.route, (context) => value.page);
  }),
};

class ExampleMainPage extends StatelessWidget {
  const ExampleMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System - Widgets'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _CategoryTile(
            title: 'Atoms',
            widgets: [
              WidgetItem(
                name: 'TextWidget',
                route: ExampleAtomsRoutes.text.route,
              ),
              WidgetItem(
                name: 'IconsWidget',
                route: ExampleAtomsRoutes.icons.route,
              ),
              WidgetItem(
                name: 'SwitchWidget',
                route: ExampleAtomsRoutes.switch_example.route,
              ),
              WidgetItem(
                name: 'CheckboxWidget',
                route: ExampleAtomsRoutes.checkbox.route,
              ),
              WidgetItem(
                name: 'LoadingWidget',
                route: ExampleAtomsRoutes.loading.route,
              ),
            ],
          ),
          _CategoryTile(
            title: 'Molecules',
            widgets: [
              WidgetItem(
                name: 'Buttons',
                route: ExampleMoleculesRoutes.buttons.route,
              ),
              WidgetItem(
                name: 'Inputs',
                route: ExampleMoleculesRoutes.inputs.route,
              ),
              WidgetItem(
                name: 'SwitchTitle',
                route: ExampleMoleculesRoutes.switch_title.route,
              ),
              WidgetItem(
                name: 'CheckboxTitle',
                route: ExampleMoleculesRoutes.checkbox_title.route,
              ),
              WidgetItem(
                name: 'ProgressBar',
                route: ExampleMoleculesRoutes.progress_bar.route,
              ),
              WidgetItem(
                name: 'Skeleton',
                route: ExampleMoleculesRoutes.skeleton.route,
              ),
              WidgetItem(
                name: 'Effects',
                route: ExampleMoleculesRoutes.effects.route,
              ),
              WidgetItem(
                name: 'FloatingButton',
                route: ExampleMoleculesRoutes.floating_button.route,
              ),
              WidgetItem(
                name: 'IconButton',
                route: ExampleMoleculesRoutes.icon_button.route,
              ),
            ],
          ),
          _CategoryTile(
            title: 'Organisms',
            widgets: [
              WidgetItem(
                name: 'Scaffold',
                route: ExampleOrganismsRoutes.scaffold.route,
              ),
              WidgetItem(
                name: 'AppBar',
                route: ExampleOrganismsRoutes.app_bar.route,
              ),
              WidgetItem(
                name: 'Dialog',
                route: ExampleOrganismsRoutes.dialog.route,
              ),
              WidgetItem(
                name: 'BottomSheet',
                route: ExampleOrganismsRoutes.bottom_sheet.route,
              ),
              WidgetItem(
                name: 'SnackBar',
                route: ExampleOrganismsRoutes.snack_bar.route,
              ),
              WidgetItem(
                name: 'Drawer',
                route: ExampleOrganismsRoutes.drawer.route,
              ),
              WidgetItem(
                name: 'Captcha',
                route: ExampleOrganismsRoutes.captcha.route,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WidgetItem {
  final String name;
  final String route;

  const WidgetItem({required this.name, required this.route});
}

class _CategoryTile extends StatefulWidget {
  final String title;
  final List<WidgetItem> widgets;

  const _CategoryTile({
    required this.title,
    required this.widgets,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          tileColor: Theme.of(context).cardColor,
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
        if (_isExpanded)
          ...widget.widgets.map(
            (widget) => ListTile(
              title: Text(
                widget.name,
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pushNamed(context, widget.route),
            ),
          ),
      ],
    );
  }
}
