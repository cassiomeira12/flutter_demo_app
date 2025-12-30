class EnvironmentEntity {
  final String appName;
  final String serverUrl;
  final String? appId;
  final String? clientKey;
  final String? restApiKey;
  final String? graphqlUrl;

  EnvironmentEntity({
    required this.appName,
    required this.serverUrl,
    required this.appId,
    required this.clientKey,
    required this.restApiKey,
    required this.graphqlUrl,
  });
}
