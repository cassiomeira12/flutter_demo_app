import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class SymmetricEncryptionService {
  Result<String> encrypt({
    required String password,
    required String data,
  });

  Result<String> decrypt({
    required String password,
    required String encryptedData,
  });

  static List<int> generateSecureKey() {
    Uint8List nextBytes(int bytes) {
      final random = Random.secure();
      final buffer = Uint8List(bytes);
      for (var i = 0; i < bytes; i++) {
        buffer[i] = random.nextInt(0xFF + 1);
      }
      return buffer;
    }

    return nextBytes(32);
  }
}
