import 'package:flutter_test/flutter_test.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';

void main() {
  const entity = LanguageFile(FileEntity(path: 'assets/pt.json', name: 'pt.json'), {});
  
  test('name', () => expect(entity.name, 'pt.json'));
  test('nameWithoutExtension', () => expect(entity.nameWithoutExtension, 'pt'));
}
