import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class CreateCredentialUseCase
    extends BaseUseCaseAsyncParam<CredentialEntity, CredentialEntity> {}

class CreateCredentialUseCaseImpl implements CreateCredentialUseCase {
  final CredentialRepository _repository;
  final HttpClient _http;

  CreateCredentialUseCaseImpl({
    required this._repository,
    required this._http,
  });

  @override
  Future<CredentialEntity> call(CredentialEntity data) async {
    final String? faviconUrl = await _requestUrlFavicon(data.faviconUrl);
    final String defaultFaviconUrl =
        'https://ui-avatars.com/api/?format=png&name=${data.name}';

    final CredentialEntity dataUpdated = data.copyWith(
      faviconUrl: faviconUrl ?? defaultFaviconUrl,
    );

    final CredentialEntity created = await _repository.create(
      dataUpdated.toMap(),
    );

    return dataUpdated.copyWith(
      objectId: created.objectId,
      createdAt: created.createdAt,
      updatedAt: created.updatedAt,
    );
  }

  Future<String?> _requestUrlFavicon(String? faviconUrl) async {
    try {
      if (faviconUrl!.isNotEmpty) {
        await _http.request(
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
