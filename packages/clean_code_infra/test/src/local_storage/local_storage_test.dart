import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() {
    AppBinding.put<LocalStorage>(SharedPreferencesLocalStorageImpl());
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('test get data', () async {
    final LocalStorage localStorage = AppBinding.find();

    String? nullValue = await localStorage.get<String>('null');
    expect(nullValue, null);

    await localStorage.set('null', 'Null');

    nullValue = await localStorage.get<String>('null');
    expect(nullValue, isNotNull);
  });

  test('test set data', () async {
    final LocalStorage localStorage = AppBinding.find();

    String? nullValue = await localStorage.get<String>('null');
    expect(nullValue, isNotNull);

    await localStorage.set('null', 'null2');

    nullValue = await localStorage.get<String>('null');
    expect(nullValue, 'null2');
  });

  test('test delete data', () async {
    final LocalStorage localStorage = AppBinding.find();

    await localStorage.set('null', 'Null');

    String? nullValue = await localStorage.get<String>('null');
    expect(nullValue, isNotNull);

    await localStorage.delete('null');

    nullValue = await localStorage.get<String>('null');
    expect(nullValue, isNull);
  });

  test('test clearAll data', () async {
    final LocalStorage localStorage = AppBinding.find();

    await localStorage.set('teste1', 'Null');
    await localStorage.set('teste2', 'Null');

    String? teste1 = await localStorage.get<String>('teste1');
    expect(teste1, isNotNull);

    String? teste2 = await localStorage.get<String>('teste2');
    expect(teste2, isNotNull);

    await localStorage.clearAll();

    teste1 = await localStorage.get<String>('teste1');
    expect(teste1, isNull);

    teste2 = await localStorage.get<String>('teste2');
    expect(teste2, isNull);
  });
}
