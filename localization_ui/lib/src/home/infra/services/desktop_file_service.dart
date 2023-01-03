import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/errors/file_service_errors.dart';
import 'package:localization_ui/src/home/domain/services/file_service.dart';
import 'package:localization_ui/src/home/domain/usecases/delete_json.dart';
import 'package:localization_ui/src/home/domain/usecases/load_json.dart';
import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
import 'package:result_dart/result_dart.dart';
import 'package:universal_io/io.dart';

import '../mappers/platform_file_mapper.dart';

class DesktopFileService implements FileService {
  final FilePicker filePicker;
  final PlatformFileMapper platformFileMapper;
  const DesktopFileService(this.platformFileMapper, this.filePicker);

  @override
  LoadJsonResult getFiles() async {
    final selectedFiles = await filePicker.pickFiles(lockParentWindow: false, allowMultiple: true);
    if (selectedFiles == null) return const Failure(NoFilesSelected());
    final response = selectedFiles.files.map(platformFileMapper.toFileEntity).toList();
    return Success(response);
  }

  @override
  ReadJsonResult getLanguagesByFiles(List<FileEntity> files) async {
    final languages = <LanguageFile>[];
    for (var file in files) {
      final stringData = file.readAsString();
      var json = jsonDecode(stringData) as Map;
      final castedJson = json.cast<String, String>();
      final language = LanguageFile(file, castedJson);
      languages.add(language);
    }
    return Success(languages);
  }

  @override
  SaveJsonResult saveLanguages(List<LanguageFile> languages) async {
    for (var language in languages) {
      await _saveFile(language);
    }

    return const Success(unit);
  }

  Future<void> _saveFile(LanguageFile language) async {
    final file = File(language.file.path!);
    await file.writeAsString(jsonEncode(language.getMap()));
  }

  @override
  DeleteJsonResult deleteLanguage(LanguageFile language) async {
    final file = File(language.file.path!);
    await file.delete();
    return const Success(unit);
  }
}
