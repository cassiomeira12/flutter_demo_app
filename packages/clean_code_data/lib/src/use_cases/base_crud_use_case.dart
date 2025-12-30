import 'package:clean_code_domain/clean_code_domain.dart';

class BaseCrudUseCaseImpl<Result> implements BaseCrudUseCase<Result> {
  final BaseCrudService<Result> _repository;

  BaseCrudUseCaseImpl({required BaseCrudService<Result> repository})
    : _repository = repository;

  @override
  Future<Result> create(BaseUseCaseParam param) {
    return _repository.create(param.toMap());
  }

  @override
  Future<void> delete(String objectId) {
    return _repository.delete(objectId);
  }

  @override
  Future<List<Result>> list() {
    return _repository.list();
  }

  @override
  Future<Result> read(String objectId) {
    return _repository.read(objectId);
  }

  @override
  Future<Result> update(String objectId, {required BaseUseCaseParam param}) {
    return _repository.update(objectId, data: param.toMap());
  }
}
