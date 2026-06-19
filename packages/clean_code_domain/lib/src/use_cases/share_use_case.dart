import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class ShareUseCase extends UseCase {
  Future<ShareResultEntity> call({
    String? title,
    String? subject,
    String? text,
    Uri? uri,
    List<File>? files,
  });
}

class ShareUseCaseImpl implements ShareUseCase {
  final ShareService _shareService;

  ShareUseCaseImpl({required this._shareService});

  @override
  Future<ShareResultEntity> call({
    String? title,
    String? subject,
    String? text,
    Uri? uri,
    List<File>? files,
  }) {
    return _shareService.share(
      title: title,
      subject: subject,
      text: text,
      uri: uri,
      files: files,
    );
  }
}
