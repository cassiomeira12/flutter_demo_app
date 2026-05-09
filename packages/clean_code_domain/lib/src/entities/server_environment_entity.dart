class ServerEnvironmentEntity {
  final String serverUrl;
  final String? appId;
  final String? clientKey;
  final String? restApiKey;
  final String? graphqlUrl;

  ServerEnvironmentEntity({
    required this.serverUrl,
    this.appId,
    this.clientKey,
    this.restApiKey,
    this.graphqlUrl,
  });
}
