import 'package:flutter/foundation.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/errors/file_service_errors.dart';
import 'package:localization_ui/src/home/domain/usecases/delete_json.dart';
import 'package:localization_ui/src/home/domain/usecases/load_json.dart';
import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
import 'package:localization_ui/src/home/presenter/extensions/file_language_extension.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';

import '../../../core/window.dart';

// ignore: must_be_immutable
class FileStore extends StreamStore<FileServiceError, FileState> with MementoMixin {
  final LoadJson loadJson;
  final ReadJson readJson;
  final SaveJson saveJson;
  final DeleteJson deleteJson;
  final WindowService window;

  int _undoAndRedoCount = 0;
  int get undoAndRedoCount => _undoAndRedoCount;
  FileState? _savedState;

  bool get isSaved => _savedState == state;

  FileStore(this.readJson, this.saveJson, this.deleteJson, this.window, this.loadJson) : super(InitFileState());

  Future<void> loadFiles() async {
    setLoading(true);
    final loadResponse = await loadJson.call();
    loadResponse.fold((files) async {
      final readResponse = await readJson.call(files);
      await Future.delayed(const Duration(milliseconds: 500));

      readResponse.map(state.loadedLanguages).fold(update, setError);
      _savedState = state;
      clearHistory();

      final firstFile = files.first;
      if (!kIsWeb) {
        final directory = firstFile.path?.substring(0, firstFile.path?.lastIndexOf('/'));
        window.concatTextWithAppName(directory!);
      }
      setLoading(false);
    }, (error) {
      setError(error);
      setLoading(false);
    });
  }

  @override
  void undo() {
    super.undo();
    _undoAndRedoCount++;
  }

  @override
  void redo() {
    super.redo();
    _undoAndRedoCount++;
  }

  void updateLanguages(List<LanguageFile> langs) {
    update(state.loadedLanguages(langs));
  }

  Future<void> saveLanguages() async {
    setLoading(true);
    final result = await saveJson.call(state.languages);
    result.map((a) => state.loadedLanguages()).fold(update, setError);
    _savedState = state;

    setLoading(false);
  }

  Future<void> addNewLanguage(String languageName) async {
    final langs = state.languages.map((e) => e.copy()).toList();
    final keys = state.keys.fold<Map<String, String>>({}, (previousValue, element) => previousValue..addAll({element: ''}));
    langs.add(LanguageFile(FileEntity(name: '$languageName.json', bytes: Uint8List.fromList([])), keys));

    update(state.loadedLanguages(langs));

    clearHistory();
  }

  void addNewKey(String key) {
    final langs = state.languages.map((e) => e.copy()).toList();
    for (var lang in langs) {
      lang.set(key, '');
    }
    update(state.loadedLanguages(langs));
  }

  void removeKey(String key) {
    final langs = state.languages.map((e) => e.copy()).toList();
    for (var lang in langs) {
      lang.deleteByKey(key);
    }
    update(state.loadedLanguages(langs));
  }

  void editKey(String oldKey, String key) {
    final langs = state.languages.map((e) => e.copy()).toList();

    for (var lang in langs) {
      final newMap = <String, String>{};
      final map = lang.getMap();
      for (var entryKey in map.keys) {
        if (entryKey == oldKey) {
          newMap[key] = map[entryKey]!;
        } else {
          newMap[entryKey] = map[entryKey]!;
        }
      }

      lang.setDicionary(newMap);
    }

    update(state.loadedLanguages(langs));
  }

  Future<void> removeLanguage(LanguageFile language) async {
    final result = await deleteJson.call(language);

    result.fold((r) async {
      final langs = state.languages.where((element) => element != language).map((e) => e.copy()).toList();
      update(state.loadedLanguages(langs));
      await saveLanguages();
      clearHistory();
    }, setError);
  }
}
