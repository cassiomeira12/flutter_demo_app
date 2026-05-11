import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointController extends BaseController {
  final GetCurrentPointsUseCase _getCurrentPointsUseCase;
  final RegisterPointUseCase _registerPointUseCase;
  final GetTotalHoursAppUseCase _getTotalHoursAppUseCase;

  CheckPointController({
    required GetCurrentPointsUseCase getCurrentPointsUseCase,
    required RegisterPointUseCase registerPointUseCase,
    required GetTotalHoursAppUseCase getTotalHoursUseCase,
  }) : _getCurrentPointsUseCase = getCurrentPointsUseCase,
       _registerPointUseCase = registerPointUseCase,
       _getTotalHoursAppUseCase = getTotalHoursUseCase;

  RxList<CheckDayPointEntity> checkPoints = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  RxString totalHours = RxString('');
  RxDouble totalBudget = RxDouble(0);

  Rx<DateTime> selectedDate = Rx(DateTime.now());

  @override
  void onReady() {
    super.onReady();
    getCurrentCheckPoints();
  }

  Future<void> getCurrentCheckPoints() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      isLoading.value = true;

      final int month = selectedDate.value.month;
      final int year = selectedDate.value.year;

      final List<dynamic> results = await Future.wait([
        _getCurrentPointsUseCase.call(month: month, year: year),
        _getTotalHoursAppUseCase.call(month: month, year: year),
      ], eagerError: true);

      checkPoints.value = results.first as List<CheckDayPointEntity>;
      totalHours.value = results.last as String;

      final int hour = int.parse(totalHours.value.split(':').first);
      final int minutes = int.parse(totalHours.value.split(':').last);

      const double timePrice = 80.10;
      final double budget = hour * timePrice + (timePrice / 60) * minutes;

      totalBudget.value = budget;
      totalHours.value = results.last;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerPoint() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      clickTagging(component: 'register_check_point_key');
      final time = DateHelper.formatHourMinute(DateTime.now());
      tagging('register_check_point', parameters: {'time': time});
      await _registerPointUseCase.call();
      await getCurrentCheckPoints();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeSelectedDate(DateTime date) async {
    selectedDate.value = date;
    getCurrentCheckPoints();
  }
}
