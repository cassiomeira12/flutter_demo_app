import 'package:integration_test/integration_test.dart';

import 'tests/blocking/blocking_test.dart' as blocking;
import 'tests/change_password/change_password_test.dart' as changepassword;
import 'tests/intro/intro_test.dart' as intro;
import 'tests/login/login_test.dart' as login;
import 'tests/settings/settings_test.dart' as settings;
import 'tests/signup/signup_test.dart' as signup;
import 'tests/update/update_test.dart' as update;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  intro.main();
  blocking.main();
  update.main();
  login.main();
  signup.main();
  settings.main();
  changepassword.main();
}
