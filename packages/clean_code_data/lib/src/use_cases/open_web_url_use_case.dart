import 'package:clean_code_domain/clean_code_domain.dart';

class OpenWebUrlUseCaseImpl implements OpenWebUrlUseCase {
  final OpenUrlService _openUrlService;

  OpenWebUrlUseCaseImpl({required OpenUrlService openUrlService})
    : _openUrlService = openUrlService;

  @override
  Future<void> call(String url) {
    return _openUrlService.openUrl(url);
  }
}
