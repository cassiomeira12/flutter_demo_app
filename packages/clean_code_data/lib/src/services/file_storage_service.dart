import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class FileStorageServiceImpl implements FileStorageService {
  @override
  Future<Directory> get temporaryDirectory async {
    final directory = await getTemporaryDirectory();
    return directory;
  }

  @override
  Future<Directory> get cacheDirectory async {
    final directory = await getApplicationCacheDirectory();
    return directory;
  }

  @override
  Future<Directory> get documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  @override
  Future<Directory?> get downloadsDirectory async {
    final directory = await getDownloadsDirectory();
    return directory;
  }

  @override
  String joinFilePath({
    required String fileName,
    required Directory directory,
  }) {
    final String path = directory.path;
    final String filePath = join(path, fileName);
    return filePath;
  }

  @override
  Future<File?> readFile({required String path}) async {
    return await IsolateUseCase.isolate<File?>(
      builder: () async {
        try {
          final File file = File(path);
          if (await file.exists()) {
            return file;
          }
          return null;
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
          return null;
        }
      },
    );
  }

  @override
  Future<File> writeFileBytes({
    required String path,
    required List<int> bytes,
  }) async {
    return await IsolateUseCase.isolate<File>(
      builder: () async {
        try {
          final File file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
          return await file.writeAsBytes(bytes);
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
          rethrow;
        }
      },
    );
  }

  @override
  Future<File> writeFileStrings({
    required String path,
    required String contents,
  }) async {
    return await IsolateUseCase.isolate<File>(
      builder: () async {
        try {
          final File file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
          return await file.writeAsString(contents);
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
          rethrow;
        }
      },
    );
  }
}
