import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/infra/infra.dart';

import 'recovery_password.dart';

class RecoveryPasswordBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<RecoveryPasswordDataSource>(
      RecoveryPasswordDataSourceImpl(http: AppBinding.find()),
    );
    AppBinding.put<RecoveryPasswordService>(
      RecoveryPasswordServiceImpl(
        recoveryPasswordDataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<RecoveryPasswordUseCase>(
      RecoveryPasswordUseCaseImpl(recoveryPasswordService: AppBinding.find()),
    );

    AppBinding.put<RecoveryPasswordController>(
      RecoveryPasswordController(recoveryPasswordUseCase: AppBinding.find()),
    );
  }
}
