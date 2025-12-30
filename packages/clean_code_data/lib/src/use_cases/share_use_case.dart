import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ShareUseCaseImpl implements ShareUseCase {
  @override
  Future<ShareResultEntity> call({
    String? title,
    String? subject,
    String? text,
    Uri? uri,
    List<File>? files,
  }) async {
    try {
      final params = ShareParams(
        title: title,
        subject: subject,
        text: text,
        uri: uri,
        // files: files?.map((file) => XFile(file.path)).toList(),
        downloadFallbackEnabled: false,
        excludedCupertinoActivities: [],
      );
      final result = await SharePlus.instance.share(params);
      return ShareResultEntity(raw: result.raw, status: result.status.name);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      return ShareResultEntity(raw: '', status: 'error');
    }
  }
}
