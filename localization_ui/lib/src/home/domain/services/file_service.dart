import '../entities/file_entity.dart';
import '../entities/language_file.dart';
import '../usecases/delete_json.dart';
import '../usecases/load_json.dart';
import '../usecases/read_json.dart';
import '../usecases/save_json.dart';

abstract class FileService {
  LoadJsonResult getFiles();
  DeleteJsonResult deleteLanguage(LanguageFile language);
  ReadJsonResult getLanguagesByFiles(List<FileEntity> files);
  SaveJsonResult saveLanguages(List<LanguageFile> languages);
}
