// ignore_for_file: leading_newlines_in_multiline_strings

import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // RSA key pair PKCS#8 PEM format (2048-bit)
  const publicKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2ZcRoSVB2kHc/rfOKN08
CYdna1InuWg0TVT7pyX3HD4+jRejbL1Pcb2mgkBVjnSHr8SqR9t+ynmTI1L8ghJZ
i8Hha6MPlRgJEpzWrmsNcvQ8yxtF/fDQ+sepzwz2cJFYVhTDOLJmSSmLQSZKF41v
mH9fOnCa1fE4D/H7Ct4TtIlKwojx0v0XVzNJyleOQQRdCs/xsiEhHvTX7/irA0cD
jHW3Y8Ddo8QklXgAbH3T5Ui8Ol7RkjEy78eXZdpJhxWy+Gccu4XROchxPxFXgbjf
RFdlTXv0HBb0nK+l34i6iVekFLe0WPu9ryl77c2LXdN7BbqQqndANjZYCFdtepM4
OQIDAQAB
-----END PUBLIC KEY-----''';

  const privateKey = '''-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDZlxGhJUHaQdz+
t84o3TwJh2drUie5aDRNVPunJfccPj6NF6NsvU9xvaaCQFWOdIevxKpH237KeZMj
UvyCElmLweFrow+VGAkSnNauaw1y9DzLG0X98ND6x6nPDPZwkVhWFMM4smZJKYtB
JkoXjW+Yf186cJrV8TgP8fsK3hO0iUrCiPHS/RdXM0nKV45BBF0Kz/GyISEe9Nfv
+KsDRwOMdbdjwN2jxCSVeABsfdPlSLw6XtGSMTLvx5dl2kmHFbL4Zxy7hdE5yHE/
EVeBuN9EV2VNe/QcFvScr6XfiLqJV6QUt7RY+72vKXvtzYtd03sFupCqd0A2NlgI
V216kzg5AgMBAAECggEAXrzaVa3pnrR3msX/sqYkykdUvZMPLbhTsWnzigLLNVZa
mMb2hlVkvjKjSWnmdniBTYPU2iWU7maBrGso+x8vMt0PH3TnR3SoGp0EEfwVZnw1
7f7pehf8fXwqkLZlpHx8GDrBBzIRvAAlHBAmSVvw/1ZR6Zl2qPj2fmbO9Zvcu4kP
yfiggnMAIL8hf7MKfoW/QOL7JbWpsr70PnByidKfVaQMjm0gQoNJdzRpnW5EGqjE
//NFD7eiQrx/0Om6Q8BUI3Lycnrv6K2/PiqCLGMv8ddGwgc5Uyv0lrbWsZrjOoUn
dYLaW8Q//1BcXNdj2peLRP5DM+VADXPWqQstWoTQcwKBgQD0M+T0kd+pU5dEt5Z5
zfLVB2Nyg0Vc4A6NCDJ8ntJdVixvVCn9CDujKLmi8LbO4R0p/E4ydRjMbATYI/r0
NfKcL1BOp8ch9l2V8iNYKSmgD2PglUvtIa8hSZ/yVJfdZR8cEdcksqw3HfeTTc0j
96s6R8nTNPewmB9D8QkL1s6tLwKBgQDkGg0L/VEHeJVSAHFdkmiZIUZShnRPu37o
k9/iki60jiaPRMfDDcpiWgsdQwGYRtf/2dc/ggmX0JUJTh9qcNU3b2UQra0R5DyB
bsy4ABCjAtfIJ/8MU37YIbfcfDDa8JX6yIuqAdMOTEEGNP/kCX/gDyjzKVovkNlb
fPE+Y3inFwKBgGUJD4Js1DfvgNeKibSNlBm1e9zGGS2q+fo52QGciHbbj3jkPpcV
D++aiuuyYkBH/VQAsq3HquHxEzQF9u+RXnZmUPiqDAauMtw2GY+BQFqb43vo6UgM
NrQ0DPwrKcYM74kijHv/fKc1O9hzSRvHfc2YJBXBhXVICy+GC3Mdhdc7AoGAQSM7
VJArQoHpyjf8J6d2nTwGU+y3bElzrUEFLzNliQQK+ODAVvAqOjnScLHA09ZvOk3g
DO+6g5L57GVVzVSZXrI93yxpfvF5YdDdPzItjg9yxWK+j6uMTnYahikk3nDTs4Dv
eUX6GlwmOXqLFHit/rL1k7LcYTbxCxI75gAL5VMCgYA0NztB/P2tE8Ttt+3hHN+l
CMmhDNuubfs8j6wa+GpyzrLRd6aeqUO9aRAFLEdJTYFfk/nJAFg5Qf2Jla4w8lDx
gVsLpcSHkeUX4jo0Q+NKCMjGeL7cDcO7BXjl1vZhbB61ASjqZRyFUsySGg3NuNq4
6Fo4kzwaOlIejZKkRZaPjg==
-----END PRIVATE KEY-----''';

  late AsymmetricEncryptionService service;

  setUp(() {
    service = RsaAsymmetricEncryptionServiceImpl();
    // service = RsaEncryptServiceImpl();
  });

  group('AsymmetricEncryptionService - encrypt', () {
    group('Sucesso', () {
      test(
        'deve retornar Result.success com string base64 não vazia '
        'quando encrypt for bem-sucedido',
        () {
          // act
          final result = service.encrypt(
            publicKey: publicKey,
            data: 'Teste123',
          );

          // assert
          expect(result, isA<Success<String>>());
          expect((result as Success<String>).value!.isNotEmpty, true);
        },
      );

      test(
        'deve retornar valores diferentes para dados diferentes com a mesma chave',
        () {
          // act
          final result1 = service.encrypt(
            publicKey: publicKey,
            data: 'Mensagem A',
          );
          final result2 = service.encrypt(
            publicKey: publicKey,
            data: 'Mensagem B',
          );

          // assert
          expect(result1, isA<Success<String>>());
          expect(result2, isA<Success<String>>());
          expect(
            (result1 as Success<String>).value,
            isNot(equals((result2 as Success<String>).value)),
          );
        },
      );

      test(
        'deve aceitar dados com caracteres especiais e acentos',
        () {
          // act
          final result = service.encrypt(
            publicKey: publicKey,
            data: r'São Paulo 123!@#\$% áéíóú ç ñ',
          );

          // assert
          expect(result, isA<Success<String>>());
          expect((result as Success<String>).value!.isNotEmpty, true);
        },
      );
    });

    group('Erro', () {
      test(
        'deve retornar Result.error com EncryptException '
        'quando a chave pública for inválida',
        () {
          // act
          final result = service.encrypt(
            publicKey: 'chave_invalida',
            data: 'teste',
          );

          // assert
          expect(result, isA<Error<String>>());
          expect(
            (result as Error<String>).error,
            isA<EncryptException>(),
          );
        },
      );

      test(
        'deve retornar Result.error quando a chave pública '
        'tiver formato PEM inválido',
        () {
          // act
          final result = service.encrypt(
            publicKey:
                '-----BEGIN PUBLIC KEY-----\ninvalid\n-----END PUBLIC KEY-----',
            data: 'teste',
          );

          // assert
          expect(result, isA<Error<String>>());
        },
      );

      test(
        'deve retornar Result.error quando a chave pública estiver vazia',
        () {
          // act
          final result = service.encrypt(
            publicKey: '',
            data: 'teste',
          );

          // assert
          expect(result, isA<Error<String>>());
        },
      );

      test(
        'deve retornar Result.error quando os dados forem '
        'muito longos para a chave',
        () {
          // arrange
          final longData = 'A' * 300;

          // act
          final result = service.encrypt(
            publicKey: publicKey,
            data: longData,
          );

          // assert
          expect(result, isA<Error<String>>());
        },
      );
    });
  });

  group('AsymmetricEncryptionService - decrypt', () {
    group('Sucesso', () {
      test(
        'deve descriptografar corretamente dados previamente criptografados',
        () {
          // arrange
          const originalData = 'Mensagem secreta';
          final encrypted = service.encrypt(
            publicKey: publicKey,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            privateKey: privateKey,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect((decrypted as Success<String>).value, equals(originalData));
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com dados contendo '
        'números e símbolos',
        () {
          // arrange
          const originalData = r'Dados: 12345!@#\$%';
          final encrypted = service.encrypt(
            publicKey: publicKey,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            privateKey: privateKey,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect((decrypted as Success<String>).value, equals(originalData));
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com dados contendo acentos',
        () {
          // arrange
          const originalData = 'Informação confidencial';
          final encrypted = service.encrypt(
            publicKey: publicKey,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            privateKey: privateKey,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect((decrypted as Success<String>).value, equals(originalData));
        },
      );

      test(
        'deve descriptografar corretamente dados previamente criptografados',
        () {
          // arrange
          const originalData = '0123456789AB';
          const encryptedData =
              'llspORGtygSTEWDRc01IbrlRkrCQazDsWIB/OMjBgSUv/vtFtCcVb8vccJkVk6C/QU859EDrQw2TrLJDtLFptaCyonNqkbyYHmwFjea4RBsvptoVbiKKRZCrJD/kEt/PwIbw0iOUzKqteb4WIBXniYO5w2tsE3wof/8MuuJiG+SIJyMhmhBSHr2LJiG/skHSLBgz8R9Vvfhnc6v1aTNAwrcUvXZt1XVfplkpozBZb4KfH7Wr9k/fZ6a9SnlNpChZY09fiSich7/uL443TKKDxYefuN4ZRmllShNq5si0dFO91EV0ZaD9GLLHLoQBntvVxpM3B82jHYOcRlc8nWDYFQ==';

          // act
          final decrypted = service.decrypt(
            privateKey: privateKey,
            encryptedData: encryptedData,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );
    });

    group('Erro', () {
      test(
        'deve retornar Result.error com EncryptException '
        'quando a chave privada for inválida',
        () {
          // act
          final result = service.decrypt(
            privateKey: 'invalida',
            encryptedData: 'dGVzdGU=',
          );

          // assert
          expect(result, isA<Error<String>>());
          expect(
            (result as Error<String>).error,
            isA<EncryptException>(),
          );
        },
      );

      test(
        'deve retornar Result.error quando a chave privada estiver vazia',
        () {
          // act
          final result = service.decrypt(
            privateKey: '',
            encryptedData: 'dGVzdGU=',
          );

          // assert
          expect(result, isA<Error<String>>());
        },
      );

      test(
        'deve retornar Result.error quando os dados criptografados '
        'forem inválidos',
        () {
          // act
          final result = service.decrypt(
            privateKey: privateKey,
            encryptedData: 'base64_invalido!!!',
          );

          // assert
          expect(result, isA<Error<String>>());
        },
      );
    });
  });

  group('AsymmetricEncryptionService - generateKeys', () {
    test(
      'deve retornar RsaEncryptKey com chaves não vazias',
      () {
        // act
        final result = service.generateKeys();

        // assert
        expect(result, isA<RsaEncryptKey>());
        expect(result.publicKey.isNotEmpty, true);
        expect(result.privateKey.isNotEmpty, true);
      },
    );

    test(
      'deve retornar RsaEncryptKey com chaves não vazias',
      () {
        // act
        final result = service.generateKeys();

        // assert
        expect(result, isA<RsaEncryptKey>());

        const originalData = 'Dados sigilosos para teste!';

        // act
        final encrypted = service.encrypt(
          publicKey: result.publicKey,
          data: originalData,
        );
        final encryptedValue = (encrypted as Success<String>).value!;
        final decrypted = service.decrypt(
          privateKey: result.privateKey,
          encryptedData: encryptedValue,
        );

        // assert
        expect(encrypted, isA<Success<String>>());
        expect(decrypted, isA<Success<String>>());
        expect(encryptedValue, isNot(equals(originalData)));
        expect((decrypted as Success<String>).value, equals(originalData));
      },
    );
  });

  group('AsymmetricEncryptionService - encrypt e decrypt integrados', () {
    test(
      'deve fazer round-trip completo de encrypt e decrypt com dados reais',
      () {
        // arrange
        const originalData = 'Dados sigilosos para teste!';

        // act
        final encrypted = service.encrypt(
          publicKey: publicKey,
          data: originalData,
        );
        final encryptedValue = (encrypted as Success<String>).value!;
        final decrypted = service.decrypt(
          privateKey: privateKey,
          encryptedData: encryptedValue,
        );

        // assert
        expect(encrypted, isA<Success<String>>());
        expect(decrypted, isA<Success<String>>());
        expect(encryptedValue, isNot(equals(originalData)));
        expect((decrypted as Success<String>).value, equals(originalData));
      },
    );

    test(
      'deve produzir ciphertext diferente para cada chamada '
      'mesmo com mesmos dados',
      () {
        // arrange
        const data = 'Mesmo texto';

        // act
        final encrypted1 = service.encrypt(
          publicKey: publicKey,
          data: data,
        );
        final encrypted2 = service.encrypt(
          publicKey: publicKey,
          data: data,
        );

        // assert
        expect(encrypted1, isA<Success<String>>());
        expect(encrypted2, isA<Success<String>>());
        // OAEP usa padding aleatório, então resultados devem ser diferentes
        expect(
          (encrypted1 as Success<String>).value,
          isNot(equals((encrypted2 as Success<String>).value)),
        );
      },
    );
  });
}
