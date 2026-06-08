import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class CheckInternetConnectionUseCase extends UseCase {
  Future<bool> call();

  Stream<bool> get internetStream;

  void dispose();
}

class CheckInternetConnectionUseCaseImpl
    implements CheckInternetConnectionUseCase {
  final InternetConnectionService _internetConnectionService;

  CheckInternetConnectionUseCaseImpl({
    required this._internetConnectionService,
  }) {
    _internetConnectionService.addStream(_internetStream);
  }

  final _internetStream = StreamController<bool>.broadcast();

  @override
  Stream<bool> get internetStream => _internetStream.stream;

  @override
  Future<bool> call() => _internetConnectionService.hasInternetAccess();

  @override
  void dispose() {
    if (!_internetStream.isClosed) {
      _internetStream.close();
    }
  }
}
