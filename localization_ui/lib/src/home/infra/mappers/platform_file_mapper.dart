import 'package:file_picker/file_picker.dart';
import 'package:localization_ui/src/home/domain/entities/file_entity.dart';
import 'package:universal_io/io.dart';

abstract class PlatformFileMapper {
  FileEntity toFileEntity(PlatformFile platformFile);
}

class DesktopPlatformFileMapper implements PlatformFileMapper {
  @override
  FileEntity toFileEntity(PlatformFile platformFile) {
    return FileEntity(
      path: platformFile.path,
      name: platformFile.name,
      bytes: File(platformFile.path!).readAsBytesSync(),
    );
  }
}

class WebPlatformFileMapper implements PlatformFileMapper {
  @override
  FileEntity toFileEntity(PlatformFile platformFile) {
    return FileEntity(
      path: null,
      name: platformFile.name,
      bytes: platformFile.bytes,
    );
  }
}
