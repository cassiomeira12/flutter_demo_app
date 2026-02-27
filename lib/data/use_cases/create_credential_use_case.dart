import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CreateCredentialUseCaseImpl implements CreateCredentialUseCase {
  final CredentialService _service;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncryptUseCase;
  final HttpClient http;

  CreateCredentialUseCaseImpl({
    required CredentialService service,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required SecurityEncryptUseCase securityEncryptUseCase,
    required this.http,
  }) : _service = service,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _securityEncryptUseCase = securityEncryptUseCase;

  @override
  Future<CredentialEntity> call(CredentialEntity data) async {
    final String? faviconUrl = await _requestUrlFavicon(data.faviconUrl);
    final String defaultFaviconUrl =
        'https://ui-avatars.com/api/?format=png&name=${data.name}';

    final CredentialEntity dataUpdated = data.copyWith(
      faviconUrl: faviconUrl ?? defaultFaviconUrl,
    );

    final String? password = await _encryptUserPasswordUseCase.decrypt();
    final CredentialEntity encryptedData = await _encryptCredential(
      dataUpdated,
      password: password!,
    );
    final CredentialEntity created = await _service.create(
      encryptedData.toMap(),
    );
    return dataUpdated.copyWith(
      objectId: created.objectId,
      createdAt: created.createdAt,
      updatedAt: created.updatedAt,
    );
  }

  Future<CredentialEntity> _encryptCredential(
    CredentialEntity credential, {
    required String password,
  }) async {
    final Map<String, dynamic> json = credential.toMap();

    final String objectId = json.remove('objectId');
    final String createdAt = json.remove('createdAt');
    final String updatedAt = json.remove('updatedAt');

    for (final key in json.keys) {
      if (json[key] != null) {
        json[key] = await _securityEncryptUseCase.encrypt(
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

  Future<String?> _requestUrlFavicon(String? faviconUrl) async {
    try {
      if (faviconUrl!.isNotEmpty) {
        await http.request(
          HttpRequest(
            url: faviconUrl,
            timeout: const Duration(seconds: 5),
          ),
          method: HttpMethod.GET,
        );
      }
      return faviconUrl;
    } catch (_) {
      return null;
    }
  }
}
