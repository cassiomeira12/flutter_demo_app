import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/emergency_history/emergency_history.dart';

class EmergencyHistoryBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<ListUserOccurrenciesUseCase>(
      ListUserOccurrenciesUseCaseImpl(
        emergencyService: AppBinding.find(),
      ),
    );

    AppBinding.put<EmergencyHistoryController>(
      EmergencyHistoryController(
        listUserOccurrenciesUseCase: AppBinding.find(),
      ),
    );
  }
}
