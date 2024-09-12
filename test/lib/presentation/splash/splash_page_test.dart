import 'package:flutter_demo_app/presentation/app.dart';
import 'package:flutter_demo_app/presentation/app_bindings.dart';
import 'package:flutter_demo_app/presentation/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late App app;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    app = App(initialRoute: AppRouter.splash.name);
  });

  setUp(() {
    AppBindings().dependencies();
  });

  tearDown(() {
    Get.deleteAll(force: true);
  });

  testWidgets('test splash page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('https://fake-api.tractian.com'), findsOneWidget);
  });
}
