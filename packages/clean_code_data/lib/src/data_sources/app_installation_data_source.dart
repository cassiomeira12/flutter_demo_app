import 'data_sources.dart';

abstract class AppInstallationDataSource implements CreateDataSource {
  Future<List<Map<String, dynamic>>> list(String userId);
}
