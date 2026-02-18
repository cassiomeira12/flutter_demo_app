import 'package:core/core.dart';

abstract class AppInstallationDataSource implements CreateDataSource {
  Future<List<Map<String, dynamic>>> list(String userId);
}
