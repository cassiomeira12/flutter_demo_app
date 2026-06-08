import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_demo_app/presentation/emergency/emergency.dart';

class EmergencyBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<EmergencyDataSource>(
      EmergencyDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
    AppBinding.put<EmergencyService>(
      EmergencyServiceImpl(
        emergencyDataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<CheckWhatsAppServerUseCase>(
      CheckWhatsAppServerUseCaseImpl(
        emergencyService: AppBinding.find(),
      ),
    );
    AppBinding.put<SendSosUseCase>(
      SendSosUseCaseImpl(
        emergencyService: AppBinding.find(),
      ),
    );

    AppBinding.put<EmergencyController>(
      EmergencyController(
        checkWhatsAppServerUseCase: AppBinding.find(),
        sendSosUseCase: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        // requestPermissionUseCase: AppBinding.find(),
        getCurrentLocationUseCase: AppBinding.find(),
        // trackLocationUseCase: AppBinding.find(),
      ),
    );
  }
}
