import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_demo_app/presentation/phone_number/phone_number_controller.dart';

class PhoneNumberBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<WhatsAppDataSource>(
      WhatsAppDataSourceImpl(http: AppBinding.find()),
    );
    AppBinding.put<WhatsAppService>(
      WhatsAppServiceImpl(dataSource: AppBinding.find()),
    );
    AppBinding.put<SendWhatsAppCodeUseCase>(
      SendWhatsAppCodeUseCaseImpl(
        whatsAppService: AppBinding.find(),
      ),
    );

    AppBinding.put<PhoneNumberController>(
      PhoneNumberController(
        sendWhatsAppCodeUseCase: AppBinding.find(),
        updateUserDataUseCase: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
      ),
    );
  }
}
