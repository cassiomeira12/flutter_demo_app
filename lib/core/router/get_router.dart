import '../core.dart';
import 'app_base_router.dart';

class GetRouter implements AppBaseRouter {
  GetRouter._();

  static final instance = GetRouter._();

  @override
  Future<T?> toNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) async {
    return await Get.toNamed<T>(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  @override
  void back<T>({int? id}) {
    return Get.back(
      id: id,
    );
  }

  @override
  Future<T?> backAllAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) async {
    return await Get.offAllNamed<T>(
      routeName,
      id: id,
    );
  }

  @override
  Future<T?> backAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) async {
    return await Get.offAndToNamed<T>(
      routeName,
      id: id,
    );
  }

  @override
  Future<T?> backUntil<T>() async {
    // TODO: implement backUntil
    throw UnimplementedError();
  }
}
