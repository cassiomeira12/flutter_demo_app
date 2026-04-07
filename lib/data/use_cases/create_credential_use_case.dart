import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CreateCredentialUseCaseImpl implements CreateCredentialUseCase {
  final CredentialRepository _repository;
  final HttpClient http;

  CreateCredentialUseCaseImpl({
    required CredentialRepository repository,
    required this.http,
  }) : _repository = repository;

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
