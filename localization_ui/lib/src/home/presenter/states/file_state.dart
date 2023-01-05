import 'package:localization_ui/src/home/domain/entities/language_file.dart';

abstract class FileState {
  final List<LanguageFile> languages;
  final Set<String> keys;

  FileState({this.languages = const [], this.keys = const {}});

  FileState loadedLanguages([List<LanguageFile>? languages]) => LoadedFileState.languages(languages: languages ?? this.languages);
}

class InitFileState extends FileState {}

class LoadedFileState extends FileState {
  LoadedFileState._({
    required List<LanguageFile> languages,
    required Set<String> keys,
  }) : super(languages: languages, keys: keys);

  factory LoadedFileState.languages({required List<LanguageFile> languages}) {
    final _keys = <String>{};
    for (var langs in languages) {
      _keys.addAll(langs.keys);
    }

    return LoadedFileState._(languages: languages, keys: _keys);
  }
}
