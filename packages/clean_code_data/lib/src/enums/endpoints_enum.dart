enum EndpointsEnum {
  ipLocation('/parse/functions/ip-address'),
  uploadInstallations('/parse/functions/installation'),
  listUserInstallations('/parse/functions/list-user-installations'),
  login('/parse/functions/login'),
  logout('/parse/logout'),
  createNotification('/parse/functions/add-notification'),
  listNotification('/parse/functions//list-notification'),
  graphql('/graphql'),
  readNotification('/parse/functions/read-notification'),
  testPushNotification('/parse/functions/test-push-notification'),
  recoveryPassword('/parse/requestPasswordReset'),
  signup('/parse/functions/signup'),
  userData('/parse/functions/me'),
  updateUserData('/parse/users/{objectId}'),
  deleteUserAccount('/parse/functions/deleteAccount'),
  changeUserPassword('/parse/functions/change-password'),
  listUsers('/parse/users'),
  listWebVisitHistory('/parse/classes/WebsiteVisitHistory'),
  subscribeTopic('/parse/functions/subscribeTopic'),
  unsubscribeTopic('/parse/functions/unsubscribeTopic'),
  subscribeUserTopic('/parse/functions/subscribeUserTopic'),
  unsubscribeUserTopic('/parse/functions/unsubscribeUserTopic'),
  listCurrentPoints('/timesheet-beefor/api/apontamento/{year}/{month}'),
  registerPoint('/timesheet-beefor/api/apontamento/registar'),
  totalCurrentMonth('/timesheet-beefor/api/totais/{month}/{year}')
  ;

  final String endpoint;

  String get endpointWithoutParams => endpoint.split('{').first;

  const EndpointsEnum(this.endpoint);
}
