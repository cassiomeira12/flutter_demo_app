import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class EmergencyHistoryController extends BaseController {
  final ListUserOccurrenciesUseCase _listUserOccurrenciesUseCase;

  EmergencyHistoryController({required this._listUserOccurrenciesUseCase});

  RxList<OccurrenceEntity> occurrencies = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  @override
  void onReady() {
    super.onReady();
    getAllOccurrencies();
  }

  Future<void> getAllOccurrencies() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      occurrencies.value = await _listUserOccurrenciesUseCase.call();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
