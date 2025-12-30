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
  feedback('/settings/feedback'),
  user('/settings/user'),
  security('/settings/security'),
  themes('/settings/themes'),
  securityBlocked('/security_blocked'),
  changePassword('/settings/user/change_password'),
  deleteAccount('/delete_account'),
  deleteAccountFinish('/delete_account/finish_account'),
  deleteAccountConfirmation('/delete_account/confirmation'),
  deleteAccountFinished('/delete_account/delete_account_finished'),
  purchase('/purchase'),
  phoneNumber('/signup/phone_number'),
  emergency('/emergency'),
  emergencyHistory('/emergency/history'),
  contacts('/contacts'),
  newContact('/contacts/new'),
  sosConfig('/settings/sos_config')
  ;

  const AppRouter(this._name);

  final String _name;

  String get name => _name;
}
