import 'package:result_dart/result_dart.dart';

import '../entities/language_file.dart';
import '../errors/file_service_errors.dart';
import '../services/file_service.dart';

typedef SaveJsonResult = Future<Result<Unit, FileServiceError>>;

abstract class SaveJson {
  SaveJsonResult call(List<LanguageFile> languages);
}

class SaveJsonImpl implements SaveJson {
  final FileService _service;

  SaveJsonImpl(this._service);

  @override
  SaveJsonResult call(List<LanguageFile> languages) async {
    return await _service.saveLanguages(languages);
  }
}
