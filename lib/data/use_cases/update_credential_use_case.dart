import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class UpdateCredentialUseCaseImpl implements UpdateCredentialUseCase {
  final CredentialRepository _repository;
  final HttpClient http;

  UpdateCredentialUseCaseImpl({
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

    final CredentialEntity updated = await _repository.update(
      dataUpdated.objectId,
      data: dataUpdated.toMap(),
    );

    return dataUpdated.copyWith(updatedAt: updated.updatedAt);
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
