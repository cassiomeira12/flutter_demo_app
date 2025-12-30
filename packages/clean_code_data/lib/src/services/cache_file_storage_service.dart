import 'dart:io';

import 'package:clean_code_domain/clean_code_domain.dart';

class CacheFileStorageServiceImpl implements CacheStorageService {
  final FileStorageUseCase _usecase;

  CacheFileStorageServiceImpl({required FileStorageUseCase fileStorageUseCase})
    : _usecase = fileStorageUseCase;

  @override
  Future<String?> load(String key) async {
    final Directory directory = await _usecase.cacheDirectory;
    final String path = _usecase.joinFilePath(
      fileName: key,
      directory: directory,
    );
    final File? file = await _usecase.readFile(path: path);
    return await file?.readAsString();
  }

  @override
  Future<void> save(String key, String data) async {
    final Directory directory = await _usecase.cacheDirectory;
    final String path = _usecase.joinFilePath(
      fileName: key,
      directory: directory,
    );
    await _usecase.writeFileStrings(path: path, contents: data);
  }
}
