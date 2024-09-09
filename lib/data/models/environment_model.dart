import '../../domain/domain.dart';

class EnvironmentModel extends EnvironmentEntity {
  EnvironmentModel({
    required super.baseUrl,
  });

  factory EnvironmentModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentModel(
      baseUrl: json['baseUrl'] as String,
    );
  }
}
