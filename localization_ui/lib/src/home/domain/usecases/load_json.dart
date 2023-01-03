import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';
import '../errors/file_service_errors.dart';
import '../services/file_service.dart';

typedef LoadJsonResult = Future<Result<List<FileEntity>, FileServiceError>>;

abstract class LoadJson {
  LoadJsonResult call();
}

class LoadJsonImpl implements LoadJson {
  final FileService _service;
  LoadJsonImpl(this._service);

  @override
  LoadJsonResult call() async {
    return await _service.getFiles();
  }
}
