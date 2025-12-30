import 'package:clean_code_domain/clean_code_domain.dart';

class OpenAppUseCaseImpl implements OpenAppUseCase {
  final OpenUrlService _openUrlService;

  OpenAppUseCaseImpl({required OpenUrlService openUrlService})
    : _openUrlService = openUrlService;

  @override
  Future<void> call(String url) {
    return _openUrlService.openApp(url);
  }
}
