import 'package:clean_code_data/clean_code_data.dart';

abstract class AppInstallationDataSource implements CreateDataSource {
  Future<List<Map<String, dynamic>>> list(String userId);
}
