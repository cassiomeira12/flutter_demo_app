import 'dart:io';

import 'package:clean_code_domain/clean_code_domain.dart';

class CacheFileStorageServiceImpl implements CacheStorageService {
  final FileStorageUseCase _fileStorageUseCase;

  CacheFileStorageServiceImpl({required this._fileStorageUseCase});

  @override
  Future<String?> load(String key) async {
    final Directory directory = await _fileStorageUseCase.cacheDirectory;
    final String path = _fileStorageUseCase.joinFilePath(
      fileName: key,
      directory: directory,
    );
    final File? file = await _fileStorageUseCase.readFile(path: path);
    return await file?.readAsString();
  }

  @override
  Future<void> save(String key, String data) async {
    final Directory directory = await _fileStorageUseCase.cacheDirectory;
    final String path = _fileStorageUseCase.joinFilePath(
      fileName: key,
      directory: directory,
    );
    await _fileStorageUseCase.writeFileStrings(path: path, contents: data);
  }
}
