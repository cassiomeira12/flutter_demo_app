import 'package:clean_code_domain/clean_code_domain.dart';

abstract class OpenWebUrlUseCase extends BaseUseCaseAsyncParam<void, String> {}

class OpenWebUrlUseCaseImpl implements OpenWebUrlUseCase {
  final OpenUrlService _openUrlService;

  OpenWebUrlUseCaseImpl({required this._openUrlService});

  @override
  Future<void> call(String url) {
    return _openUrlService.openUrl(url);
  }
}
