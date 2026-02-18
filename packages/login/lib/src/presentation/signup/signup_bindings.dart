import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/infra/infra.dart';
import 'package:login/src/presentation/signup/signup.dart';

class SignUpBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SignupDataSource>(
      SignupDataSourceImpl(http: AppBinding.find()),
    );
    AppBinding.put<SignupService>(
      SignupServiceImpl(signUpDataSource: AppBinding.find()),
    );
    AppBinding.put<CreateUserUseCase>(
      CreateUserUseCaseImpl(
        signupService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
      ),
    );

    AppBinding.put<SignUpController>(
      SignUpController(
        createUserUseCase: AppBinding.find(),
        updateUserLocaleUseCase: AppBinding.find(),
        uploadInstallationAppUseCase: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
      ),
    );
  }
}
