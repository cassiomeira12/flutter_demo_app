import 'dart:io';

abstract class FileStorageUseCase {
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
