class SecurityEnvironmentEntity {
  final String encryptKey;
  final String serverRSAPublicKeyBase64;
  final String secretOTP;

  SecurityEnvironmentEntity({
    required this.encryptKey,
    required this.serverRSAPublicKeyBase64,
    required this.secretOTP,
  });
}
