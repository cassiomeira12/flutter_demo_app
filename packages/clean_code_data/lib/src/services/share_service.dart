import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ShareServiceImpl implements ShareService {
  @override
  Future<ShareResultEntity> share({
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
      Log.error(error, stackTrace);
      return ShareResultEntity(raw: '', status: 'error');
    }
  }
}
