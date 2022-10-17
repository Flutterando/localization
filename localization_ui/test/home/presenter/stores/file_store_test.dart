// import 'package:flutter_test/flutter_test.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
// import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
// import 'package:localization_ui/src/home/presenter/states/file_state.dart';
// import 'package:localization_ui/src/home/presenter/stores/file_store.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:value_listenable_test/value_listenable_test.dart';

// class ReadJsonMock extends Mock implements ReadJson {}

// class SaveJsonMock extends Mock implements SaveJson {}

// void main() {
//   late FileStore store;
//   late ReadJson readJson;
//   late SaveJson saveJson;

//   setUp(() {
//     readJson = ReadJsonMock();
//     saveJson = SaveJsonMock();
//     store = FileStore(readJson, saveJson);
//   });

//   valueListenableTest<FileStore>(
//     'readJson',
//     build: () {
//       when(() => readJson.call(any())).thenAnswer((_) async => const Right([]));
//       return store;
//     },
//     act: (store) => store.setDirectoryAndLoad(''),
//     expect: () => [
//       isA<LoadingFileState>(),
//       isA<LoadedFileState>(),
//     ],
//   );

//   valueListenableTest<FileStore>(
//     'saveJson',
//     build: () {
//       when(() => saveJson.call([])).thenAnswer((_) async => const Right(unit));
//       return store;
//     },
//     act: (store) => store.saveLanguages(),
//     expect: () => [
//       isA<LoadingFileState>(),
//       isA<LoadedFileState>(),
//     ],
//   );
// }
