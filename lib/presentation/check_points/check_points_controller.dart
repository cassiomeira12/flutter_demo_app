import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointsController extends LifecycleController {
  final GetCurrentPointsUseCase _getCurrentPointsUseCase;
  final RegisterPointUseCase _registerPointUseCase;
  final GetTotalHoursAppUseCase _getTotalHoursAppUseCase;

  CheckPointsController({
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

  @override
  void onAppForeground() {
    final CheckDayPointEntity? checkDay = checkPoints
        .where((workDay) => workDay.today)
        .firstOrNull;
    if (checkDay != null && checkDay.day != DateTime.now().day) {
      changeSelectedDate(DateTime.now());
    }
  }

  Future<void> getCurrentCheckPoints() async {
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'get-current-point-performance-tracking',
      operation: 'get-current-check-points',
    );
    try {
      isLoading.value = true;
      errorMessage.value = '';

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
    } on BaseException catch (error) {
      track.catchError(error: error);
      errorMessage.value = error.message.tr;
    } catch (error, stackTrace) {
      Log.error('registerPoint', error: error, stackTrace: stackTrace);
      track.catchError(error: error);
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
      track.finish();
    }
  }

  Future<void> registerPoint() async {
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'register-point-performance-tracking',
      operation: 'register-point',
    );
    try {
      isLoading.value = true;
      errorMessage.value = '';
      clickTagging(component: 'register_check_point_key');
      final time = DateHelper.formatHourMinute(DateTime.now());
      tagging('register_check_point', parameters: {'time': time});
      await _registerPointUseCase.call();
      track.finish();
      await getCurrentCheckPoints();
    } on BaseException catch (error) {
      track.catchError(error: error);
      if (error.message.contains('work_point_already_created')) {
        rethrow;
      }
      Log.error('registerPoint', error: error);
      errorMessage.value = error.message.tr;
    } catch (error, stackTrace) {
      Log.error('registerPoint', error: error, stackTrace: stackTrace);
      errorMessage.value = error.toString();
      track.catchError(error: error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeSelectedDate(DateTime date) async {
    selectedDate.value = date;
    getCurrentCheckPoints();
  }
}
