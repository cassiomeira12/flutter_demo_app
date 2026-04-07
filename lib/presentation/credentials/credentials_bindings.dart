import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';

class CredentialsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CredentialsStore>(CredentialsStore());

    AppBinding.put<CredentialDataSource>(
      CredentialDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
    AppBinding.put<CredentialService>(
      CredentialServiceImpl(
        dataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<CredentialRepository>(
      CredentialRepositoryImpl(
        service: AppBinding.find(),
        checkInternetUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        securityEncryptUseCase: AppBinding.find(),
      ),
    );
    AppBinding.put<ListCredentialUseCase>(
      ListCredentialUseCaseImpl(
        repository: AppBinding.find(),
      ),
    );

    AppBinding.put<UpdateCredentialUseCase>(
      UpdateCredentialUseCaseImpl(
        repository: AppBinding.find(),
        http: AppBinding.find(),
      ),
    );

    AppBinding.put<CredentialsController>(
      CredentialsController(
        credentialsStore: AppBinding.find(),
        listCredentialUseCase: AppBinding.find(),
        updateCredentialUseCase: AppBinding.find(),
        credentialRepository: AppBinding.find(),
      ),
    );
  }
}
