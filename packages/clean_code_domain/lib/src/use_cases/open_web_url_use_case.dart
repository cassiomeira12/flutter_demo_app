import 'package:clean_code_domain/clean_code_domain.dart';

abstract class OpenWebUrlUseCase extends BaseUseCaseAsyncParam<void, String> {}

class OpenWebUrlUseCaseImpl implements OpenWebUrlUseCase {
  final OpenUrlService _service;

  OpenWebUrlUseCaseImpl({
    required OpenUrlService openUrlService,
  }) : _service = openUrlService;

  @override
  Future<void> call(String url) {
    return _service.openUrl(url);
  }
}
