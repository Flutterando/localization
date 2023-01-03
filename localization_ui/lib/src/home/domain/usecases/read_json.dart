import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';
import '../entities/language_file.dart';
import '../errors/file_service_errors.dart';
import '../services/file_service.dart';

typedef ReadJsonResult = Future<Result<List<LanguageFile>, FileServiceError>>;

abstract class ReadJson {
  ReadJsonResult call(List<FileEntity> files);
}

class ReadJsonImpl implements ReadJson {
  final FileService _service;
  ReadJsonImpl(this._service);

  @override
  ReadJsonResult call(List<FileEntity> files) async {
    return await _service.getLanguagesByFiles(files);
  }
}
