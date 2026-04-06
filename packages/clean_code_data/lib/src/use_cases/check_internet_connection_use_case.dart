import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class CheckInternetConnectionUseCaseImpl
    implements CheckInternetConnectionUseCase {
  final InternetConnectionService _service;

  CheckInternetConnectionUseCaseImpl({
    required InternetConnectionService internetConnectionService,
  }) : _service = internetConnectionService {
    _service.addStream(_internetStream);
  }

  final _internetStream = StreamController<bool>.broadcast();

  @override
  Stream<bool> get internetStream => _internetStream.stream;

  @override
  Future<bool> call() => _service.hasInternetAccess();

  @override
  void pauseStream() => _service.pauseStream();

  @override
  void resumeStream() => _service.resumeStream();

  @override
  void dispose() {
    _internetStream.close();
    _service.dispose();
  }
}
