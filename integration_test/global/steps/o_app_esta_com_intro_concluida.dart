import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O app está com intro concluída
Future<void> oAppEstaComIntroConcluida(WidgetTester tester) async {
  await AppBinding.find<LocalStorage>().set(INTRO_DONE, true);
}
