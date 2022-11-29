import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:localization_ui/src/core/window.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/usecases/delete_json.dart';
import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:triple_test/triple_test.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

class ReadJsonMock extends Mock implements ReadJson {}

class SaveJsonMock extends Mock implements SaveJson {}

class DeleteJsonMock extends Mock implements DeleteJson {}

class WindowServiceMock extends Mock implements WindowService {}

void main() {
  late FileStore store;
  late ReadJson readJson;
  late SaveJson saveJson;
  late DeleteJson deleteJson;
  late WindowService windowService;

  setUp(() {
    readJson = ReadJsonMock();
    saveJson = SaveJsonMock();
    deleteJson = DeleteJsonMock();
    windowService = WindowServiceMock();
    store = FileStore(
      readJson,
      saveJson,
      deleteJson,
      windowService,
    );
  });

  storeTest<FileStore>(
    'readJson',
    build: () {
      when(() => readJson.call(any())).thenAnswer((_) async => const Right([]));
      return store;
    },
    act: (store) => store.setDirectoryAndLoad(''),
    expect: () => [
      tripleLoading,
      tripleState,
    ],
  );

  storeTest<FileStore>(
    'saveJson',
    build: () {
      when(() => saveJson.call([])).thenAnswer((_) async => const Right(unit));
      return store;
    },
    act: (store) => store.saveLanguages(),
    expect: () => [
      tripleLoading,
      tripleState,
      tripleLoading,
    ],
  );
}
