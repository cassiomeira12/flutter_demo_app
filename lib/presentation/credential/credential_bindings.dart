import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credential/credential.dart';

class CredentialBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CreateCredentialUseCase>(
      CreateCredentialUseCaseImpl(
        repository: AppBinding.find(),
        http: AppBinding.find(),
      ),
    );
    AppBinding.put<UpdateCredentialUseCase>(
      UpdateCredentialUseCaseImpl(
        repository: AppBinding.find(),
        http: AppBinding.find(),
      ),
    );
    AppBinding.put<DeleteCredentialUseCase>(
      DeleteCredentialUseCaseImpl(
        repository: AppBinding.find(),
      ),
    );

    AppBinding.put<CredentialController>(
      CredentialController(
        createCredentialUseCase: AppBinding.find(),
        updateCredentialUseCase: AppBinding.find(),
        deleteCredentialUseCase: AppBinding.find(),
        credentialsStore: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
        clipboardUseCase: AppBinding.find(),
      ),
    );
  }
}
