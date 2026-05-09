import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_method_handler.dart';

void main() {
  MockMethodHandler.ensureInitializedWithMock();

  setUpAll(() {
    MockMethodHandler.getApplicationDocumentsDirectory();

    AppBinding.put<LocalStorage>(HiveLocalStorage());
  });

  tearDownAll(() async {
    final LocalStorage storage = AppBinding.find();
    await storage.clearAll();
    AppBinding.deleteAll();
  });

  test('should get a null value', () async {
    final LocalStorage storage = AppBinding.find();

    final String? value = await storage.get<String>('key');
    expect(value, isNull);
  });

  test('should add and get an num value', () async {
    final LocalStorage storage = AppBinding.find();

    int? integer = await storage.get<int>('integer');
    double? floating = await storage.get<double>('double');

    expect(integer, isNull);
    expect(floating, isNull);

    await storage.set<int>('integer', 1);
    await storage.set<double>('double', 1.0);

    integer = await storage.get<int>('integer');
    expect(integer, isNotNull);

    floating = await storage.get<double>('double');
    expect(floating, isNotNull);
  });

  test('should add and get an bool value', () async {
    final LocalStorage storage = AppBinding.find();

    bool? boolean = await storage.get<bool>('bool');
    expect(boolean, isNull);

    await storage.set<bool>('bool', true);

    boolean = await storage.get<bool>('bool');
    expect(boolean, isNotNull);
    expect(boolean, true);

    await storage.set<bool>('bool', false);

    boolean = await storage.get<bool>('bool');
    expect(boolean, isNotNull);
    expect(boolean, false);
  });

  test('should add and get an String value', () async {
    final LocalStorage storage = AppBinding.find();

    String? text = await storage.get<String>('String');
    expect(text, isNull);

    await storage.set<String>('String', 'String');

    text = await storage.get<String>('String');
    expect(text, isNotNull);
    expect(text, 'String');
  });

  test('should add and get an List value', () async {
    final LocalStorage storage = AppBinding.find();

    List<int>? integer = await storage.get<List<int>>('list integer');
    List<double>? floating = await storage.get<List<double>>('list double');
    List<bool>? boolean = await storage.get<List<bool>>('list bool');
    List<String>? text = await storage.get<List<String>>('list String');

    expect(integer, isNull);
    expect(floating, isNull);
    expect(boolean, isNull);
    expect(text, isNull);

    await storage.set<List<int>>('list integer', [1, 2]);
    await storage.set<List<double>>('list double', [1.0, 2.0]);
    await storage.set<List<bool>>('list bool', [true, false]);
    await storage.set<List<String>>('list String', ['String1', 'String2']);

    integer = await storage.get<List<int>>('list integer');
    floating = await storage.get<List<double>>('list double');
    boolean = await storage.get<List<bool>>('list bool');
    text = await storage.get<List<String>>('list String');

    expect(integer, isNotNull);
    expect(floating, isNotNull);
    expect(boolean, isNotNull);
    expect(text, isNotNull);

    expect(integer, [1, 2]);
    expect(floating, [1.0, 2.0]);
    expect(boolean, [true, false]);
    expect(text, ['String1', 'String2']);
  });

  test('should add and get an Map value', () async {
    final LocalStorage storage = AppBinding.find();

    var integer = await storage.get<Map<String, dynamic>>('map integer');
    var floating = await storage.get<Map<String, dynamic>>('map double');
    var boolean = await storage.get<Map<String, dynamic>>('map bool');
    var text = await storage.get<Map<String, dynamic>>('map String');

    expect(integer, isNull);
    expect(floating, isNull);
    expect(boolean, isNull);
    expect(text, isNull);

    await storage.set<Map<String, dynamic>>('map integer', {'key': 1});
    await storage.set<Map<String, dynamic>>('map double', {'key': 1.0});
    await storage.set<Map<String, dynamic>>('map bool', {'key': true});
    await storage.set<Map<String, dynamic>>('map String', {'key': 'String'});

    integer = await storage.get<Map<String, dynamic>>('map integer');
    floating = await storage.get<Map<String, dynamic>>('map double');
    boolean = await storage.get<Map<String, dynamic>>('map bool');
    text = await storage.get<Map<String, dynamic>>('map String');

    expect(integer, isNotNull);
    expect(floating, isNotNull);
    expect(boolean, isNotNull);
    expect(text, isNotNull);

    expect(integer, {'key': 1});
    expect(floating, {'key': 1.0});
    expect(boolean, {'key': true});
    expect(text, {'key': 'String'});
  });

  test('should get all keys', () async {
    final LocalStorage storage = AppBinding.find();

    List<String>? keys = await storage.getKeys();
    if (keys.isEmpty) {
      await storage.set<String>('key', 'value');
    }
    keys = await storage.getKeys();
    expect(keys.isEmpty, false);
  });

  test('should delete each value', () async {
    final LocalStorage storage = AppBinding.find();

    List<String>? keys = await storage.getKeys();
    for (final key in keys) {
      await storage.delete(key);
    }
    keys = await storage.getKeys();
    expect(keys.isEmpty, true);
  });

  test('should clear all values', () async {
    final LocalStorage storage = AppBinding.find();

    List<String>? keys = await storage.getKeys();
    if (keys.isEmpty) {
      await storage.set<String>('key', 'value');
    }
    keys = await storage.getKeys();
    expect(keys.isEmpty, false);
    await storage.clearAll();
    keys = await storage.getKeys();
    expect(keys.isEmpty, true);
  });
}
