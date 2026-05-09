part of 'organisms_example.dart';

enum ExampleOrganismsRoutes {
  scaffold('/example/organisms/buttons', ExampleScaffoldPage()),
  app_bar('/example/organisms/inputs', ExampleAppBarPage()),
  dialog('/example/organisms/switch_title', ExampleDialogPage()),
  bottom_sheet(
    '/example/organisms/checkbox_title',
    ExampleBottomSheetPage(),
  ),
  //modal('/example/organisms/progress_bar', ExampleModalPage()),
  //navigator('/example/organisms/skeleton', ExampleNavigatorPage()),
  snack_bar('/example/organisms/effects', ExampleSnackBarPage()),
  //scroll('/example/organisms/floating_button', ExampleScrollPage()),
  drawer('/example/organisms/icon_button', ExampleDrawerPage()),
  captcha('/example/organisms/icon_button', ExampleCaptchaPage())
  ;

  final String route;
  final Widget page;

  const ExampleOrganismsRoutes(this.route, this.page);
}
