import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class ShareService {
  Future<ShareResultEntity> share({
    String? title,
    String? subject,
    String? text,
    Uri? uri,
    List<File>? files,
  });
}
