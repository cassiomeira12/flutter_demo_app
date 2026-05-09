import 'package:clean_code_domain/clean_code_domain.dart';

abstract class BaseEntity extends ParserToJson {
  final String objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
    };
  }
}
