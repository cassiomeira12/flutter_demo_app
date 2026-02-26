import 'dart:io';

import 'package:clean_code_domain/clean_code_domain.dart';

class CacheFileStorageServiceImpl implements CacheStorageService {
  final FileStorageUseCase _fileStorage;

  CacheFileStorageServiceImpl({
    required FileStorageUseCase fileStorageUseCase,
  }) : _fileStorage = fileStorageUseCase;

  @override
  Future<String?> load(String key) async {
    final Directory directory = await _fileStorage.cacheDirectory;
    final String path = _fileStorage.joinFilePath(
      fileName: key,
      directory: directory,
    );
    final File? file = await _fileStorage.readFile(path: path);
    return await file?.readAsString();
  }

  @override
  Future<void> save(String key, String data) async {
    final Directory directory = await _fileStorage.cacheDirectory;
    final String path = _fileStorage.joinFilePath(
      fileName: key,
      directory: directory,
    );
    await _fileStorage.writeFileStrings(path: path, contents: data);
  }
}
