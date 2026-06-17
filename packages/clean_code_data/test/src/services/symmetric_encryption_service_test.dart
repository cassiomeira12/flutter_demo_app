import 'dart:convert';

import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SymmetricEncryptionService service;

  setUp(() {
    service = Salsa20SymmetricEncryptionServiceImpl();
    // service = SecurityEncryptServiceImpl();
  });

  group('SymmetricEncryptionService - encrypt', () {
    group('Sucesso', () {
      test(
        'deve retornar Result<String> com sucesso contendo IV de 12 caracteres '
        'seguido de dados criptografados em base64 quando data tem 12 caracteres',
        () {
          // arrange
          const password = 'minhaSenha123';
          const data = '0123456789AB'; // exatamente 12 caracteres

          // act
          final result = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result, isA<Success<String>>());
          final encryptedPayload = (result as Success<String>).value!;
          expect(encryptedPayload.length, greaterThan(12));

          // Os primeiros 12 caracteres são o IV em base64
          final ivEncoded = encryptedPayload.substring(0, 12);
          expect(ivEncoded.length, equals(12));
          expect(() => base64.decode(ivEncoded), returnsNormally);

          // O restante deve ser base64 válido
          final encryptedData = encryptedPayload.substring(12);
          expect(() => base64.decode(encryptedData), returnsNormally);
        },
      );

      test(
        'deve gerar IVs diferentes para cada chamada mesmo com mesmos dados e senha',
        () {
          // arrange
          const password = 'senha';
          const data = '0123456789AB';

          // act
          final result1 = service.encrypt(
            password: password,
            data: data,
          );
          final result2 = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result1, isA<Success<String>>());
          expect(result2, isA<Success<String>>());

          final value1 = (result1 as Success<String>).value!;
          final value2 = (result2 as Success<String>).value!;

          // O IV (primeiros 12 chars) deve ser diferente
          final iv1 = value1.substring(0, 12);
          final iv2 = value2.substring(0, 12);
          expect(iv1, isNot(equals(iv2)));
        },
      );

      test(
        'deve aceitar senha vazia',
        () {
          // arrange
          const password = '';
          const data = 'abcdefghijkl'; // exatamente 12 caracteres

          // act
          final result = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result, isA<Success<String>>());
          final encryptedPayload = (result as Success<String>).value!;
          expect(encryptedPayload.length, greaterThan(12));

          final ivEncoded = encryptedPayload.substring(0, 12);
          expect(() => base64.decode(ivEncoded), returnsNormally);
        },
      );

      test(
        'deve aceitar dados com caracteres especiais de 12 caracteres',
        () {
          // arrange
          const password = 'senha';
          // 12 caracteres ASCII especiais
          const data = r'!@#$%&*()_+=';

          // act
          final result = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result, isA<Success<String>>());
          final encryptedPayload = (result as Success<String>).value!;
          expect(encryptedPayload.length, greaterThan(12));

          final ivEncoded = encryptedPayload.substring(0, 12);
          expect(() => base64.decode(ivEncoded), returnsNormally);
        },
      );

      test(
        'deve aceitar dados com apenas números de 12 caracteres',
        () {
          // arrange
          const password = 'senha';
          const data = '123456789012'; // exatamente 12 caracteres

          // act
          final result = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result, isA<Success<String>>());
          final encryptedPayload = (result as Success<String>).value!;
          expect(encryptedPayload.length, greaterThan(12));

          final ivEncoded = encryptedPayload.substring(0, 12);
          expect(() => base64.decode(ivEncoded), returnsNormally);
        },
      );

      test(
        'deve aceitar senha longa',
        () {
          // arrange
          final password = 'a' * 100;
          const data = '0123456789AB';

          // act
          final result = service.encrypt(
            password: password,
            data: data,
          );

          // assert
          expect(result, isA<Success<String>>());
          final encryptedPayload = (result as Success<String>).value!;
          expect(encryptedPayload.length, greaterThan(12));
        },
      );
    });
  });

  group('SymmetricEncryptionService - decrypt', () {
    group('Sucesso', () {
      test(
        'deve descriptografar corretamente dados previamente criptografados '
        'com a mesma senha',
        () {
          // arrange
          const password = 'minhaSenha123';
          const originalData = '0123456789AB';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com senha vazia',
        () {
          // arrange
          const password = '';
          const originalData = 'abcdefghijkl';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com senha longa',
        () {
          // arrange
          final password = 'a' * 100;
          const originalData = '0123456789AB';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com caracteres especiais',
        () {
          // arrange
          const password = 'senhaForte!@#';
          // 12 caracteres ASCII especiais
          const originalData = r'!@#$%&*()_+=';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );

      test(
        'deve fazer round-trip encrypt/decrypt com dados numéricos',
        () {
          // arrange
          const password = 'senha';
          const originalData = '123456789012';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        },
      );

      test(
        'deve descriptografar corretamente dados previamente criptografados',
        () {
          // arrange
          const password = 'minhaSenha123';
          const originalData = '0123456789AB';
          const encryptedData = 'yK7SW3jH7nM=VG+PJ9Hm5uhHHV9b';

          // act
          final decrypted = service.decrypt(
            password: password,
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
        'deve retornar InvalidEncryptedDataException quando encryptedData '
        'for menor que 12 caracteres',
        () {
          // arrange
          const password = 'senha';
          const encryptedData = 'curto'; // 5 caracteres

          // act
          final result = service.decrypt(
            password: password,
            encryptedData: encryptedData,
          );

          // assert
          expect(result, isA<Error<String>>());
          expect(
            (result as Error<String>).error,
            isA<InvalidEncryptedDataException>(),
          );
        },
      );

      test(
        'deve retornar InvalidEncryptedDataException quando encryptedData '
        'tiver exatamente 11 caracteres',
        () {
          // arrange
          const password = 'senha';
          final encryptedData = 'a' * 11;

          // act
          final result = service.decrypt(
            password: password,
            encryptedData: encryptedData,
          );

          // assert
          expect(result, isA<Error<String>>());
          expect(
            (result as Error<String>).error,
            isA<InvalidEncryptedDataException>(),
          );
        },
      );

      test(
        'deve retornar EncryptException quando o IV não for base64 válido',
        () {
          // arrange
          const password = 'senha';
          const encryptedData = 'INVALID_BASE64!!!dados';

          // act
          final result = service.decrypt(
            password: password,
            encryptedData: encryptedData,
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
        'deve retornar EncryptException quando a parte criptografada '
        'não for base64 válido',
        () {
          // arrange
          // IV válido (12 chars) + dados inválidos
          const invalidData =
              'AQIDBAUGBwg='; // base64 válido de 8 bytes = 12 chars

          // act
          final result = service.decrypt(
            password: 'senha',
            encryptedData: '$invalidData!!!base64_invalido!!!',
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
        'deve retornar dados diferentes do original quando a senha estiver errada',
        () {
          // arrange
          const password = 'senhaCorreta';
          const originalData = '0123456789AB';

          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          // act
          final decrypted = service.decrypt(
            password: 'senhaErrada',
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            isNot(equals(originalData)),
          );
        },
      );
    });
  });

  group('SymmetricEncryptionService - integração encrypt e decrypt', () {
    test(
      'deve fazer round-trip completo com dados e senha reais',
      () {
        // arrange
        const originalData = 'Flutter lind'; // exatamente 12 caracteres
        const password = 'MinhaSenhaSuperSegura123!@#';

        // act
        final encrypted = service.encrypt(
          password: password,
          data: originalData,
        );
        final encryptedValue = (encrypted as Success<String>).value!;

        final decrypted = service.decrypt(
          password: password,
          encryptedData: encryptedValue,
        );

        // assert
        expect(encryptedValue, isNot(equals(originalData)));
        expect(decrypted, isA<Success<String>>());
        expect(
          (decrypted as Success<String>).value,
          equals(originalData),
        );
      },
    );

    test(
      'senhas diferentes devem produzir ciphertext diferente para os mesmos dados',
      () {
        // arrange
        const data = '0123456789AB';

        // act
        final result1 = service.encrypt(
          password: 'senhaA',
          data: data,
        );
        final result2 = service.encrypt(
          password: 'senhaB',
          data: data,
        );

        // assert
        expect(result1, isA<Success<String>>());
        expect(result2, isA<Success<String>>());

        final value1 = (result1 as Success<String>).value!;
        final value2 = (result2 as Success<String>).value!;

        // Os IVs podem ser diferentes (aleatório), mas os dados criptografados
        // após o IV também serão diferentes devido à chave MD5 diferente
        final encryptedData1 = value1.substring(12);
        final encryptedData2 = value2.substring(12);
        expect(encryptedData1, isNot(equals(encryptedData2)));
      },
    );

    test(
      'deve funcionar com múltiplas operações de encrypt/decrypt em sequência',
      () {
        // arrange
        const password = 'senhaSequencial';
        final dados = <String>[
          'Primeira men', // 12 caracteres
          '0123456789AB', // 12 caracteres
          '123456789012', // 12 caracteres
        ];

        for (final originalData in dados) {
          // act
          final encrypted = service.encrypt(
            password: password,
            data: originalData,
          );
          final encryptedValue = (encrypted as Success<String>).value!;

          final decrypted = service.decrypt(
            password: password,
            encryptedData: encryptedValue,
          );

          // assert
          expect(decrypted, isA<Success<String>>());
          expect(
            (decrypted as Success<String>).value,
            equals(originalData),
          );
        }
      },
    );

    test(
      'deve fazer round-trip com senha contendo caracteres especiais',
      () {
        // arrange
        const password = r'áéíóú!@#$%&*()';
        const originalData = 'Teste 12345!';

        // act
        final encrypted = service.encrypt(
          password: password,
          data: originalData,
        );
        final encryptedValue = (encrypted as Success<String>).value!;

        final decrypted = service.decrypt(
          password: password,
          encryptedData: encryptedValue,
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
}
