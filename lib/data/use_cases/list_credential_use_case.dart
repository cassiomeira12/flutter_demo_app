import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class ListCredentialUseCaseImpl implements ListCredentialUseCase {
  final CredentialService _service;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncryptUseCase;

  ListCredentialUseCaseImpl({
    required CredentialService service,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required SecurityEncryptUseCase securityEncryptUseCase,
  }) : _service = service,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _securityEncryptUseCase = securityEncryptUseCase;

  @override
  Future<List<CredentialEntity>> call() async {
    final List<CredentialEntity> list = await _service.list();
    return await _decryptCredentialList(list);
  }

  Future<List<CredentialEntity>> _decryptCredentialList(
    List<CredentialEntity> list,
  ) async {
    final String? password = await _encryptUserPasswordUseCase.decrypt();
    final List<CredentialEntity> decryptedList = List.empty(growable: true);
    for (final credential in list) {
      final decryptedCredential = await _decryptCredential(
        credential,
        password: password!,
      );
      decryptedList.add(decryptedCredential);
    }
    decryptedList.sort((a, b) => a.name.compareTo(b.name));
    return decryptedList;
  }

  Future<CredentialEntity> _decryptCredential(
    CredentialEntity credential, {
    required String password,
  }) async {
    final Map<String, dynamic> json = credential.toMap();

    final String objectId = json.remove('objectId');
    final String createdAt = json.remove('createdAt');
    final String updatedAt = json.remove('updatedAt');

    for (final key in json.keys) {
      if (json[key] != null) {
        json[key] = await _securityEncryptUseCase.decrypt(
          password: password,
          data: json[key],
        );
      }
    }

    json['objectId'] = objectId;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;

    return CredentialModel.fromMap(json) as CredentialEntity;
  }
}
