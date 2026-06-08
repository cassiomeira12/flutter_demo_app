import 'package:clean_code_domain/clean_code_domain.dart';

abstract class OpenAppUseCase extends BaseUseCaseAsyncParam<void, String> {}

class OpenAppUseCaseImpl implements OpenAppUseCase {
  final OpenUrlService _service;

  OpenAppUseCaseImpl({
    required OpenUrlService openUrlService,
  }) : _service = openUrlService;

  @override
  Future<void> call(String url) {
    return _service.openApp(url);
  }
}
