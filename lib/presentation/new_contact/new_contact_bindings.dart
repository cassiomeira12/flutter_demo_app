import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/new_contact/new_contact_controller.dart';

class NewContactBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<ContactService>(
      ContactServiceImpl(),
    );
    AppBinding.put<GetLocalContactUseCase>(
      GetLocalContactUseCaseImpl(
        contactService: AppBinding.find(),
      ),
    );

    AppBinding.put<CreateSafetyContactUseCase>(
      CreateSafetyContactUseCaseImpl(
        safetyContactService: AppBinding.find(),
      ),
    );

    AppBinding.put<NewContactController>(
      NewContactController(
        createSafetyContactUseCase: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        getLocalContactUseCase: AppBinding.find(),
      ),
    );
  }
}
