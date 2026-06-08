import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_demo_app/presentation/contacts/contacts.dart';

class ContactsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SafetyContactDataSource>(
      SafetyContactDataSourceImpl(http: AppBinding.find()),
    );
    AppBinding.put<SafetyContactService>(
      SafetyContactServiceImpl(
        safetyContactDataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<ListSafetyContactUseCase>(
      ListSafetyContactUseCaseImpl(
        safetyContactService: AppBinding.find(),
      ),
    );
    AppBinding.put<DeleteSafetyContactUseCase>(
      DeleteSafetyContactUseCaseImpl(
        safetyContactService: AppBinding.find(),
      ),
    );

    AppBinding.put<ContactsController>(
      ContactsController(
        listSafetyContactUseCase: AppBinding.find(),
        deleteSafetyContactUseCase: AppBinding.find(),
      ),
    );
  }
}
