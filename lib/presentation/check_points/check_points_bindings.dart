import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_store.dart';

class CheckPointsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CheckPointDataSource>(
      CheckPointDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
    AppBinding.put<CheckPointService>(
      CheckPointServiceImpl(
        checkPointDataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<GetCurrentPointsUseCase>(
      GetCurrentPointsUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<RegisterPointUseCase>(
      RegisterPointUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<GetTotalHoursAppUseCase>(
      GetTotalHoursAppUseCaseImpl(
        checkPointService: AppBinding.find(),
      ),
    );
    AppBinding.put<CheckPointsStore>(
      CheckPointsStore(),
    );

    AppBinding.put<CheckPointsController>(
      CheckPointsController(
        getCurrentPointsUseCase: AppBinding.find(),
        registerPointUseCase: AppBinding.find(),
        getTotalHoursUseCase: AppBinding.find(),
        checkPointsStore: AppBinding.find(),
      ),
    );
  }
}
