enum AppRouter {
  splash('/'),
  home('/home');

  const AppRouter(this.route);

  final String route;

  String get name => route;
}
