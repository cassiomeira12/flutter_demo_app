import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class ListenableBaseController<T> extends BaseController {
  final RxList<T> list = RxList.empty();
  final RxBool isLoading = RxBool(true);
  final RxString errorMessage = RxString('');

  Future<List<T>> Function() get fetchDataFunction;

  @override
  void onReady() {
    super.onReady();
    onFetchListData();
  }

  Future<void> onFetchListData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      list.value = await fetchDataFunction.call();
    } on BaseException catch (error) {
      errorMessage.value = error.message.tr;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
