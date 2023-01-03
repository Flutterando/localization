import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:localization_ui/src/core/window.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:localization_ui/src/home/domain/usecases/delete_json.dart';
import 'package:localization_ui/src/home/domain/usecases/load_json.dart';
import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

class LoadJsonMock extends Mock implements LoadJson {}

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
  late LoadJson loadJson;

  setUp(() {
    readJson = ReadJsonMock();
    saveJson = SaveJsonMock();
    deleteJson = DeleteJsonMock();
    windowService = WindowServiceMock();
    loadJson = LoadJsonMock();
    store = FileStore(readJson, saveJson, deleteJson, windowService, loadJson);
  });
  final englishFile = FileEntity(
    name: 'en.json',
    path: './test/jsons/en.json',
    bytes: Uint8List.fromList(utf8.encode('{"hello-text": "Hello"}')),
  );
  final portugueseFile = FileEntity(
    name: 'pt.json',
    path: './test/jsons/pt.json',
    bytes: Uint8List.fromList(utf8.encode('{"hello-text": "Olá"}')),
  );

  test('readJson', () async {
    when(() => loadJson.call()).thenAnswer((_) async => Success([englishFile, portugueseFile]));
    when(() => readJson.call(any())).thenAnswer((_) async => const Success([]));
    await store.loadFiles();

    // Verify json was loaded
    verify(() => loadJson.call()).called(1);

    // Verify json was readed
    verify(() => readJson.call(any())).called(1);

    // Wait next state
    await store.selectState.first;

    // Verify state is LoadedFileState
    expect(store.state, isA<LoadedFileState>());
  });

  test('readJson', () async {
    // when(() => loadJson.call()).thenAnswer((_) async => Success([englishFile, portugueseFile]));
    // when(() => readJson.call(any())).thenAnswer((_) async => const Success([]));
    when(() => saveJson.call(any())).thenAnswer((_) async => const Success(unit));
    await store.saveLanguages();

    // Verify json was saved
    verify(() => saveJson.call(any())).called(1);

    // Wait next state
    await store.selectState.first;

    // Verify state is LoadedFileState
    expect(store.state, isA<LoadedFileState>());
  });
}
