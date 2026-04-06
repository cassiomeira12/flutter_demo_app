import 'package:dependency/dependency.dart';

abstract class BaseRepository<T> {
  ValueNotifier<List<ValueNotifier<T>>> get valueListenable;

  Future<void> initLocalDatabase();

  int Function(T a, T b)? get sort;

  Future<T> encrypt(T item) async => item;

  Future<T> decrypt(T item) async => item;

  Future<T> create(Map<String, dynamic> data);

  Future<T> read(String objectId);

  Future<T> update(
    String objectId, {
    required Map<String, dynamic> data,
  });

  Future<void> delete(String objectId);

  Future<void> deleteLocalDatabase();

  Future<void> fetch();
}
