part of 'molecules_example.dart';

enum ExampleMoleculesRoutes {
  buttons('/example/molecules/buttons', ExampleButtonsPage()),
  inputs('/example/molecules/inputs', ExampleInputsPage()),
  switch_title('/example/molecules/switch_title', ExampleSwitchTitlePage()),
  checkbox_title(
    '/example/molecules/checkbox_title',
    ExampleCheckboxTitlePage(),
  ),
  progress_bar('/example/molecules/progress_bar', ExampleProgressBarPage()),
  skeleton('/example/molecules/skeleton', ExampleSkeletonPage()),
  effects('/example/molecules/effects', ExampleEffectsPage()),
  // image('/example/molecules/image', ExampleImagePage()),
  floating_button(
    '/example/molecules/floating_button',
    ExampleFloatingButtonPage(),
  ),
  icon_button('/example/molecules/icon_button', ExampleIconButtonPage()),
  ;

  final String route;
  final Widget page;

  const ExampleMoleculesRoutes(this.route, this.page);
}
