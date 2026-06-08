import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CredentialRepositoryImpl extends BaseRepositoryImpl<CredentialEntity>
    implements CredentialRepository {
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncryptUseCase;

  CredentialRepositoryImpl({
    super.localDatabaseName = 'local_credentials',
    required CredentialService super.service,
    required super.checkInternetUseCase,
    required super.localStorageUseCase,
    required super.localDatabase,
    required this._encryptUserPasswordUseCase,
    required this._securityEncryptUseCase,
  });

  String? _encrypterKeyPassword;

  @override
  Future<void> initLocalDatabase() async {
    _encrypterKeyPassword = await _encryptUserPasswordUseCase.decrypt();
    return super.initLocalDatabase();
  }

  @override
  int Function(CredentialEntity a, CredentialEntity b)? get sort =>
      credentialSort;

  int credentialSort(CredentialEntity a, CredentialEntity b) =>
      a.name.compareTo(b.name);

  @override
  Future<CredentialEntity> encrypt(CredentialEntity item) async {
    final Map<String, dynamic> json = item.toMap();

    final String objectId = json.remove('objectId');
    final String? createdAt = json.remove('createdAt');
    final String? updatedAt = json.remove('updatedAt');

    for (final key in json.keys) {
      if (json[key] != null) {
        json[key] = await _securityEncryptUseCase.encrypt(
          password: _encrypterKeyPassword!,
          data: json[key],
        );
      }
    }

    json['objectId'] = objectId;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;

    return CredentialModel.fromMap(json) as CredentialEntity;
  }

  @override
  Future<CredentialEntity> decrypt(CredentialEntity item) async {
    final Map<String, dynamic> json = item.toMap();

    final String objectId = json.remove('objectId');
    final String? createdAt = json.remove('createdAt');
    final String? updatedAt = json.remove('updatedAt');

    for (final key in json.keys) {
      if (json[key] != null) {
        json[key] = await _securityEncryptUseCase.decrypt(
          password: _encrypterKeyPassword!,
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
