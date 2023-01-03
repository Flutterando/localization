import 'package:result_dart/result_dart.dart';

import '../entities/language_file.dart';
import '../errors/file_service_errors.dart';
import '../services/file_service.dart';

typedef DeleteJsonResult = Future<Result<Unit, FileServiceError>>;

abstract class DeleteJson {
  DeleteJsonResult call(LanguageFile language);
}

class DeleteJsonImpl implements DeleteJson {
  final FileService _service;

  DeleteJsonImpl(this._service);

  @override
  DeleteJsonResult call(LanguageFile language) async {
    return await _service.deleteLanguage(language);
  }
}
