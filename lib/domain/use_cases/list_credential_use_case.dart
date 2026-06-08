import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class ListCredentialUseCase
    extends BaseUseCaseAsync<List<CredentialEntity>> {}

class ListCredentialUseCaseImpl implements ListCredentialUseCase {
  final CredentialRepository _repository;

  ListCredentialUseCaseImpl({
    required this._repository,
  });

  @override
  Future<List<CredentialEntity>> call() async {
    await _repository.fetch();
    return _repository.valueListenable.value.map((item) => item.value).toList();
  }
}
