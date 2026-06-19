import 'package:clean_code_domain/clean_code_domain.dart';

abstract class OpenAppUseCase extends BaseUseCaseAsyncParam<void, String> {}

class OpenAppUseCaseImpl implements OpenAppUseCase {
  final OpenUrlService _openUrlService;

  OpenAppUseCaseImpl({required this._openUrlService});

  @override
  Future<void> call(String url) {
    return _openUrlService.openApp(url);
  }
}
