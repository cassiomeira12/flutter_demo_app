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
  sendWhatsAppCode('/parse/functions/send-whatsapp-code'),
  listUserOccurrencies('/parse/functions/list-occurrencies'),
  changeSOSConfig('/parse/functions/changeSOSConfig'),
  isWhatsAppAvailable('/parse/functions/available'),
  sendSOS('/parse/functions/sos'),
  createSafetyContact('/parse/functions/add-safety-contact'),
  listSafetyContact('/parse/functions/list-safety-contact'),
  deleteSafetyContact('/parse/functions/delete-safety-contact')
  ;

  final String endpoint;

  String get endpointWithoutParams => endpoint.split('{').first;

  const EndpointsEnum(this.endpoint);
}
