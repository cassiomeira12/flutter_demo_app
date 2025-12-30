import 'package:core/core.dart';

class DeleteAccountFinishedController extends BaseController {
  void close() {
    AppNavigator.backAllAndToNamed(AppRouter.splash);
  }
}
