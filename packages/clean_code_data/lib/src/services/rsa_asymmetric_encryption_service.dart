import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

/// Represents a parsed ASN.1 DER element with its tag and value bytes.
///
/// The value contains only the content bytes (after tag and length),
/// not the full DER encoding.
typedef _Asn1Element = ({int tag, Uint8List value});

/// RSA encryption service implementation using PointyCastle.
///
/// Generates 2048-bit RSA key pairs, encrypts data with a public key,
/// and decrypts data with the corresponding private key.
/// Keys are encoded in PEM format (PKCS#1) for storage and exchange.
class RsaAsymmetricEncryptionServiceImpl
    implements AsymmetricEncryptionService {
  // --- ASN.1 DER constants ---
  static const int _tagInteger = 0x02;
  static const int _tagSequence = 0x30;

  /// Creates a FortunaRandom instance seeded with cryptographically
  /// secure random bytes from the platform.
  FortunaRandom get _secureRandom {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  // ---------------------------------------------------------------------------
  // DER encoding helpers
  // ---------------------------------------------------------------------------

  /// Encodes an ASN.1 DER length field.
  Uint8List _encodeLength(int length) {
    if (length <= 0x7F) {
      return Uint8List.fromList([length]);
    }

    final bytes = <int>[];
    var len = length;
    while (len > 0) {
      bytes.insert(0, len & 0xFF);
      len >>= 8;
    }
    bytes.insert(0, 0x80 | bytes.length);
    return Uint8List.fromList(bytes);
  }

  /// Decodes an ASN.1 DER length field returning (length, valueStartOffset).
  (int length, int valueStart) _decodeLength(
    Uint8List data,
    int offset,
  ) {
    final firstByte = data[offset];
    if ((firstByte & 0x80) == 0) {
      return (firstByte, offset + 1);
    }

    final numBytes = firstByte & 0x7F;
    var length = 0;
    for (var i = 0; i < numBytes; i++) {
      length = (length << 8) | data[offset + 1 + i];
    }
    return (length, offset + 1 + numBytes);
  }

  /// Converts a [BigInt] to a big-endian byte representation suitable for
  /// ASN.1 INTEGER encoding (two's complement, minimal bytes).
  ///
  /// Adds a leading 0x00 padding byte if the MSB is set to keep the value
  /// positive in two's complement.
  Uint8List _bigIntToBytes(BigInt number) {
    if (number == BigInt.zero) {
      return Uint8List.fromList([0]);
    }

    final hex = number.toRadixString(16);
    final paddedHex = hex.length.isOdd ? '0$hex' : hex;

    final bytes = Uint8List(paddedHex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(paddedHex.substring(i * 2, i * 2 + 2), radix: 16);
    }

    // Add leading zero if MSB is set (keep positive in two's complement)
    if (bytes[0] & 0x80 != 0) {
      final padded = Uint8List(bytes.length + 1);
      padded[0] = 0;
      padded.setRange(1, padded.length, bytes);
      return padded;
    }

    return bytes;
  }

  /// Converts big-endian bytes back to [BigInt].
  BigInt _bytesToBigInt(Uint8List bytes) {
    var result = BigInt.zero;
    for (var i = 0; i < bytes.length; i++) {
      result = (result << 8) | BigInt.from(bytes[i]);
    }
    return result;
  }

  /// Encodes a [BigInt] value as an ASN.1 DER INTEGER.
  Uint8List _encodeInteger(BigInt value) {
    final rawBytes = _bigIntToBytes(value);
    final length = _encodeLength(rawBytes.length);
    final result = Uint8List(1 + length.length + rawBytes.length);
    result[0] = _tagInteger;
    result.setRange(1, 1 + length.length, length);
    result.setRange(1 + length.length, result.length, rawBytes);
    return result;
  }

  /// Encodes a list of DER-encoded elements as an ASN.1 DER SEQUENCE.
  Uint8List _encodeSequence(List<Uint8List> elements) {
    final content = Uint8List.fromList(elements.expand((e) => e).toList());
    final length = _encodeLength(content.length);
    final result = Uint8List(1 + length.length + content.length);
    result[0] = _tagSequence;
    result.setRange(1, 1 + length.length, length);
    result.setRange(1 + length.length, result.length, content);
    return result;
  }

  // ---------------------------------------------------------------------------
  // PEM helpers
  // ---------------------------------------------------------------------------

  /// Encodes DER-encoded bytes into PEM format with the given [label].
  String _encodeToPem(Uint8List derBytes, String label) {
    final base64Str = base64.encode(derBytes);
    final buffer = StringBuffer()..writeln('-----BEGIN $label-----');

    for (var i = 0; i < base64Str.length; i += 64) {
      final end = (i + 64 < base64Str.length) ? i + 64 : base64Str.length;
      buffer.writeln(base64Str.substring(i, end));
    }

    buffer.write('-----END $label-----');
    return buffer.toString();
  }

  /// Decodes a PEM string into DER-encoded bytes.
  Uint8List _decodePem(String pem) {
    final lines = pem.split(RegExp(r'\r?\n'));
    final content = lines
        .skipWhile((line) => !line.startsWith('-----BEGIN'))
        .skip(1)
        .takeWhile((line) => !line.startsWith('-----END'))
        .map((line) => line.trim())
        .join();
    return base64.decode(content);
  }

  /// Parses an ASN.1 DER SEQUENCE and returns its child elements.
  List<_Asn1Element> _parseSequence(Uint8List data) {
    if (data[0] != _tagSequence) {
      throw const FormatException('Expected ASN.1 SEQUENCE tag');
    }

    var offset = 1;
    final (contentLength, valueStart) = _decodeLength(data, offset);
    offset = valueStart;

    final elements = <_Asn1Element>[];
    final endOffset = offset + contentLength;

    while (offset < endOffset) {
      final tag = data[offset];
      offset++;

      final (elemLength, elemValueStart) = _decodeLength(data, offset);
      offset = elemValueStart;

      elements.add((
        tag: tag,
        value: data.sublist(offset, offset + elemLength),
      ));

      offset += elemLength;
    }

    return elements;
  }

  // ---------------------------------------------------------------------------
  // Key parsing
  // ---------------------------------------------------------------------------

  /// Extracts INTEGER value bytes from a list of parsed ASN.1 elements.
  ///
  /// Returns only the elements with INTEGER tag, throwing if none found.
  List<Uint8List> _extractIntegers(List<_Asn1Element> elements) {
    final integers = elements
        .where((e) => e.tag == _tagInteger)
        .map((e) => e.value)
        .toList();
    return integers;
  }

  /// Parses a PEM-encoded RSA public key.
  ///
  /// Supports both PKCS#1 (`RSA PUBLIC KEY`) and
  /// PKCS#8/X.509 (`PUBLIC KEY`) formats.
  RSAPublicKey _parsePublicKey(String pem) {
    final derBytes = _decodePem(pem);
    final elements = _parseSequence(derBytes);

    // PKCS#8 (X.509 SubjectPublicKeyInfo):
    // SEQUENCE { AlgorithmIdentifier (SEQUENCE), BIT STRING (wrapped PKCS#1) }
    if (elements.length >= 2 && elements[1].tag == 0x03) {
      // BIT STRING: first byte is unused bits count, then the wrapped PKCS#1 key
      final bitStringValue = elements[1].value;
      if (bitStringValue.length > 1) {
        final innerSequence = _parseSequence(
          Uint8List.sublistView(bitStringValue, 1),
        );
        final integers = _extractIntegers(innerSequence);
        if (integers.length >= 2) {
          return RSAPublicKey(
            _bytesToBigInt(integers[0]),
            _bytesToBigInt(integers[1]),
          );
        }
      }
    }

    // PKCS#1: SEQUENCE { INTEGER modulus, INTEGER exponent }
    final integers = _extractIntegers(elements);
    if (integers.length >= 2) {
      return RSAPublicKey(
        _bytesToBigInt(integers[0]),
        _bytesToBigInt(integers[1]),
      );
    }

    throw const FormatException(
      'Invalid RSA public key: could not find modulus and exponent',
    );
  }

  /// Parses a PEM-encoded RSA private key.
  ///
  /// Supports both PKCS#1 (`RSA PRIVATE KEY`) and
  /// PKCS#8 (`PRIVATE KEY`) formats.
  RSAPrivateKey _parsePrivateKey(String pem) {
    final derBytes = _decodePem(pem);
    final elements = _parseSequence(derBytes);

    // PKCS#8: SEQUENCE { INTEGER version, SEQUENCE { OID, NULL },
    //                     OCTET STRING (wrapped PKCS#1) }
    if (elements.length >= 2) {
      for (final element in elements) {
        if (element.tag == 0x04) {
          // OCTET STRING containing the wrapped PKCS#1 key
          try {
            final innerSequence = _parseSequence(element.value);
            final integers = _extractIntegers(innerSequence);
            if (integers.length >= 6) {
              return _createPrivateKey(integers);
            }
          } catch (_) {
            // Not a valid inner sequence, continue to try PKCS#1
          }
        }
      }
    }

    // PKCS#1: SEQUENCE { INTEGER version, INTEGER n, INTEGER e, INTEGER d, ... }
    final integers = _extractIntegers(elements);
    if (integers.length >= 6) {
      return _createPrivateKey(integers);
    }

    throw const FormatException(
      'Invalid RSA private key: expected at least 6 integers',
    );
  }

  /// Creates an [RSAPrivateKey] from a list of INTEGER values
  /// in PKCS#1 order.
  ///
  /// Expected order: [version, modulus, publicExponent, privateExponent,
  /// p, q, dp, dq, qInv, ...]
  RSAPrivateKey _createPrivateKey(List<Uint8List> integers) {
    final modulus = _bytesToBigInt(integers[1]);
    final privateExponent = _bytesToBigInt(integers[3]);
    final p = _bytesToBigInt(integers[4]);
    final q = _bytesToBigInt(integers[5]);
    return RSAPrivateKey(modulus, privateExponent, p, q);
  }

  // ---------------------------------------------------------------------------
  // Key encoding
  // ---------------------------------------------------------------------------

  /// Encodes an [RSAPublicKey] to PKCS#1 PEM format.
  String _publicKeyToPem(RSAPublicKey key) {
    final derBytes = _encodeSequence([
      _encodeInteger(key.modulus!),
      _encodeInteger(key.publicExponent!),
    ]);
    return _encodeToPem(derBytes, 'RSA PUBLIC KEY');
  }

  /// Encodes an [RSAPrivateKey] to PKCS#1 PEM format.
  ///
  /// Includes the CRT parameters (exponent1, exponent2, coefficient)
  /// required by the PKCS#1 private key structure.
  String _privateKeyToPem(RSAPrivateKey key) {
    final pSub1 = key.p! - BigInt.one;
    final qSub1 = key.q! - BigInt.one;

    final derBytes = _encodeSequence([
      _encodeInteger(BigInt.zero), // version
      _encodeInteger(key.modulus!), // n
      _encodeInteger(key.publicExponent!), // e
      _encodeInteger(key.privateExponent!), // d
      _encodeInteger(key.p!), // p
      _encodeInteger(key.q!), // q
      _encodeInteger(key.privateExponent! % pSub1), // dp
      _encodeInteger(key.privateExponent! % qSub1), // dq
      _encodeInteger(key.q!.modInverse(key.p!)), // qInv
    ]);
    return _encodeToPem(derBytes, 'RSA PRIVATE KEY');
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  @override
  RsaEncryptKey generateKeys() {
    try {
      const int keySize = 2048;
      const int certainty = 64;
      final publicExponent = BigInt.parse('65537');

      final keyGen = RSAKeyGenerator()
        ..init(
          ParametersWithRandom(
            RSAKeyGeneratorParameters(
              publicExponent,
              keySize,
              certainty,
            ),
            _secureRandom,
          ),
        );

      final pair = keyGen.generateKeyPair();
      final RSAPublicKey publicKey = pair.publicKey as RSAPublicKey;
      final RSAPrivateKey privateKey = pair.privateKey as RSAPrivateKey;

      return RsaEncryptKey(
        publicKey: _publicKeyToPem(publicKey),
        privateKey: _privateKeyToPem(privateKey),
      );
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Result<String> encrypt({required String publicKey, required String data}) {
    try {
      final rsaPublicKey = _parsePublicKey(publicKey);

      final cipher = OAEPEncoding(RSAEngine())
        ..init(
          true,
          PublicKeyParameter<RSAPublicKey>(rsaPublicKey),
        );

      final inputData = Uint8List.fromList(utf8.encode(data));
      final encrypted = cipher.process(inputData);

      return Result.success(base64.encode(encrypted));
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      return Result.error(
        EncryptException(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Result<String> decrypt({
    required String privateKey,
    required String encryptedData,
  }) {
    try {
      final rsaPrivateKey = _parsePrivateKey(privateKey);

      final cipher = OAEPEncoding(RSAEngine())
        ..init(
          false,
          PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey),
        );

      final data = base64.decode(encryptedData);
      final decrypted = cipher.process(Uint8List.fromList(data));

      return Result.success(utf8.decode(decrypted));
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      return Result.error(
        EncryptException(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
