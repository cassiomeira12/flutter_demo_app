import 'package:flutter_demo_app/presentation/app.dart';
import 'package:flutter_demo_app/presentation/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late App app;

  setUpAll(() {
    app = App(initialRoute: AppRouter.splash.route);
  });

  tearDown(() {
    Get.deleteAll(force: true);
  });

  testWidgets('teste splash page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('https://fake-api.tractian.com'), findsOneWidget);
  });
}
