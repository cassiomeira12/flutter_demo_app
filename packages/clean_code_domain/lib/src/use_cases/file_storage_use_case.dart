import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class FileStorageUseCase extends UseCase {
  Future<Directory> get temporaryDirectory;

  Future<Directory> get cacheDirectory;

  Future<Directory> get documentsDirectory;

  Future<Directory?> get downloadsDirectory;

  String joinFilePath({required String fileName, required Directory directory});

  Future<File?> readFile({required String path});

  Future<File> writeFileBytes({required String path, required List<int> bytes});

  Future<File> writeFileStrings({
    required String path,
    required String contents,
  });
}

class FileStorageUseCaseImpl implements FileStorageUseCase {
  final FileStorageService _fileStorageService;

  FileStorageUseCaseImpl({required this._fileStorageService});

  @override
  Future<Directory> get temporaryDirectory =>
      _fileStorageService.temporaryDirectory;
  @override
  Future<Directory> get cacheDirectory => _fileStorageService.cacheDirectory;
  @override
  Future<Directory> get documentsDirectory =>
      _fileStorageService.documentsDirectory;
  @override
  Future<Directory?> get downloadsDirectory =>
      _fileStorageService.downloadsDirectory;

  @override
  String joinFilePath({
    required String fileName,
    required Directory directory,
  }) {
    return _fileStorageService.joinFilePath(
      fileName: fileName,
      directory: directory,
    );
  }

  @override
  Future<File?> readFile({required String path}) {
    return _fileStorageService.readFile(path: path);
  }

  @override
  Future<File> writeFileBytes({
    required String path,
    required List<int> bytes,
  }) {
    return _fileStorageService.writeFileBytes(
      path: path,
      bytes: bytes,
    );
  }

  @override
  Future<File> writeFileStrings({
    required String path,
    required String contents,
  }) {
    return _fileStorageService.writeFileStrings(
      path: path,
      contents: contents,
    );
  }
}
