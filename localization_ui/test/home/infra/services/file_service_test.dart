import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:localization_ui/src/home/domain/errors/file_service_errors.dart';
import 'package:localization_ui/src/home/infra/mappers/platform_file_mapper.dart';
import 'package:localization_ui/src/home/infra/services/desktop_file_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFilePicker extends Mock implements FilePicker {}

void main() {
  late DesktopFileService service;
  late FilePicker filePicker;

  setUp(() {
    final fileMapper = DesktopPlatformFileMapper();
    filePicker = MockFilePicker();
    service = DesktopFileService(fileMapper, filePicker);
  });

  group('read json:', () {
    group('right content', () {
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

      test('right content 1 file', () async {
        final result = await service.getLanguagesByFiles([englishFile]);
        final list = result.getOrElse((l) => []);
        expect(list.length, 1);
        expect(list[0].read('hello-text'), 'Hello');
      });

      test('right content 2 files', () async {
        final result = await service.getLanguagesByFiles([englishFile, portugueseFile]);
        final list = result.getOrElse((l) => []);
        expect(list.length, 2);
        expect(list[0].read('hello-text'), 'Hello');
        expect(list[1].read('hello-text'), 'Olá');
      });
    });

    test('thows NoFilesSelected when NO files were selected', () async {
      when(() => filePicker.pickFiles(lockParentWindow: any(named: 'lockParentWindow'), allowMultiple: any(named: 'allowMultiple')))
          .thenAnswer((invocation) async => null);
      final result = await service.getFiles();
      expect(result.fold((success) => success, (failure) => failure), isA<NoFilesSelected>());
    });
  });
}
