part of 'atoms_example.dart';

enum ExampleAtomsRoutes {
  text('/example/atoms/text', ExampleTextPage()),
  icons('/example/atoms/icons', ExampleIconsPage()),
  switch_example('/example/atoms/switch_example', ExampleSwitchPage()),
  checkbox('/example/atoms/checkbox', ExampleCheckboxPage()),
  loading('/example/atoms/loading', ExampleLoadingPage())
  ;

  final String route;
  final Widget page;

  const ExampleAtomsRoutes(this.route, this.page);
}
