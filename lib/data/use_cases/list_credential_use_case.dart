import 'package:flutter_demo_app/domain/domain.dart';

class ListCredentialUseCaseImpl implements ListCredentialUseCase {
  final CredentialRepository _repository;

  ListCredentialUseCaseImpl({
    required CredentialRepository repository,
  }) : _repository = repository;

  @override
  Future<List<CredentialEntity>> call() async {
    await _repository.fetch();
    return _repository.valueListenable.value.map((item) => item.value).toList();
  }
}
