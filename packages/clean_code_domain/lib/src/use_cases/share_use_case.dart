import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class ShareUseCase {
  Future<ShareResultEntity> call({
    String? title,
    String? subject,
    String? text,
    Uri? uri,
    List<File>? files,
  });
}
