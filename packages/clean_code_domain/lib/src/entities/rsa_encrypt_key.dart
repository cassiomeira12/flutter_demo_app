import 'package:clean_code_domain/clean_code_domain.dart';

class RsaEncryptKey extends ParserToJson {
  final String publicKey;
  final String privateKey;

  RsaEncryptKey({
    required this.publicKey,
    required this.privateKey,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'privateKey': privateKey,
    };
  }
}
