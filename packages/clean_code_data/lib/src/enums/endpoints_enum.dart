enum EndpointsEnum {
  ipLocation('http://ip-api.com/json'),
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
  createCredential('/parse/classes/Credential'),
  updateCredential('/parse/classes/Credential/{objectId}'),
  listCredential('/parse/classes/Credential'),
  deleteCredential('/parse/classes/Credential/{objectId}')
  ;

  final String endpoint;

  String get endpointWithoutParams => endpoint.split('{').first;

  const EndpointsEnum(this.endpoint);
}
