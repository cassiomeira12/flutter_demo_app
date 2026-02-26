import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/check_point/check_point.dart';

class CheckPointBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UpdateWorkDayUseCase>(
      UpdateWorkDayUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<UpdateHourPointUseCase>(
      UpdateHourPointUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<DeleteHourPointUseCase>(
      DeleteHourPointUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<RegisterCustomPointUseCase>(
      RegisterCustomPointUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );

    AppBinding.put<CheckPointController>(
      CheckPointController(
        updateWorkDayUseCase: AppBinding.find(),
        updateHourPointUseCase: AppBinding.find(),
        deleteHourPointUseCase: AppBinding.find(),
        registerCustomPointUseCase: AppBinding.find(),
        checkPointsController: AppBinding.find(),
        checkPointsStore: AppBinding.find(),
      ),
    );
  }
}
