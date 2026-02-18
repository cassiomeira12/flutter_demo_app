enum AppRouter {
  initial('/'),
  splash('/splash'),
  web('/web'),
  unknown('/unknown'),
  webview('/webview'),
  intro('/intro'),
  login('/login'),
  recoveryPassword('/recovery_password'),
  signup('/signup'),
  home('/home'),
  admin('/admin'),
  users('/users'),
  usersDetails('/users/details'),
  adminCrud('/admin_crud'),
  update('/update'),
  forceUpdate('/force_update'),
  blocking('/blocking'),
  pushNotifications('/push_notifications'),
  notifications('/notifications'),
  notificationsSettings('/notifications/settings'),
  webVisitHistory('/web-visit-history'),
  settings('/settings'),
  about('/settings/about'),
  user('/settings/user'),
  security('/settings/security'),
  securityBlocked('/security_blocked'),
  changePassword('/settings/user/change_password'),
  deleteAccount('/delete_account'),
  deleteAccountFinish('/delete_account/finish_account'),
  deleteAccountConfirmation('/delete_account/confirmation'),
  deleteAccountFinished('/delete_account/delete_account_finished'),
  purchase('/purchase')
  ;

  const AppRouter(this._name);

  final String _name;

  String get name => _name;
}
