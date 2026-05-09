import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_account/src/presentation/delete_account_finish/delete_account_finish_controller.dart';

void main() {
  late DeleteAccountFinishController subject;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  setUp(() {
    subject = DeleteAccountFinishController();
  });

  group('openNextPage', () {
    test('deve executar sem erros quando chamado', () {
      // arrange & act & assert
      // O método navigates using AppNavigator.toNamed(AppRouter.deleteAccountConfirmation)
      // Tested indirectly - just verify it doesn't throw synchronously
      expect(() => subject.openNextPage(), returnsNormally);
    });
  });
}
