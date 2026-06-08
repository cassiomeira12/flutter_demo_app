import 'package:clean_code_domain/clean_code_domain.dart';

class BaseCrudUseCaseImpl<T> implements BaseCrudUseCase<T> {
  final BaseCrudService<T> _repository;

  BaseCrudUseCaseImpl({required this._repository});

  @override
  Future<T> create(BaseUseCaseParam param) {
    return _repository.create(param.toMap());
  }

  @override
  Future<void> delete(String objectId) {
    return _repository.delete(objectId);
  }

  @override
  Future<List<T>> list() {
    return _repository.list();
  }

  @override
  Future<T> read(String objectId) {
    return _repository.read(objectId);
  }

  @override
  Future<T> update(String objectId, {required BaseUseCaseParam param}) {
    return _repository.update(objectId, data: param.toMap());
  }
}
