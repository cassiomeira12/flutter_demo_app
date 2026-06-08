import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await InfraModuleBindings().injectDependencies();

    await AppBinding.replace<LoginDataSource>(
      WorkPointLoginDataSource(
        http: AppBinding.find(),
      ),
    );
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('should login success', () async {
    final LoginDataSource dataSource = AppBinding.find();

    final Map<String, dynamic> data = await dataSource.login(
      username: faker.internet.userName(),
      password: faker.internet.password(length: 6),
    );

    expect(data, isNotNull);
    expect(data, isNotEmpty);

    expect(data['id'], '4fb0ce0b-7f3a-47ba-95e0-b9e3ae3003af');
    expect(data['idPessoa'], '62f4be67-b9dc-4b53-854c-97e1c9d8933f');
    expect(data['idOrganizacao'], '53221ea9-2f0f-4cee-647c-08d81e97a40a');
    expect(data['token'], isNotNull);
  });
}
