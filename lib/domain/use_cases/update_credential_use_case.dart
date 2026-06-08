import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class UpdateCredentialUseCase
    extends BaseUseCaseAsyncParam<CredentialEntity, CredentialEntity> {}

class UpdateCredentialUseCaseImpl implements UpdateCredentialUseCase {
  final CredentialRepository _repository;
  final HttpClient _http;

  UpdateCredentialUseCaseImpl({
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

    final CredentialEntity updated = await _repository.update(
      dataUpdated.objectId,
      data: dataUpdated.toMap(),
    );

    return dataUpdated.copyWith(updatedAt: updated.updatedAt);
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
    } on HttpException catch (error) {
      if (error.statusCode == 403) {
        return faviconUrl;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
