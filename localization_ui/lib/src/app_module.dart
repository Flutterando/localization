import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization_ui/src/home/domain/usecases/load_json.dart';

import 'core/platform_bind.dart';
import 'core/window.dart';
import 'home/domain/usecases/delete_json.dart';
import 'home/domain/usecases/read_json.dart';
import 'home/domain/usecases/save_json.dart';
import 'home/infra/mappers/platform_file_mapper.dart';
import 'home/infra/services/desktop_file_service.dart';
import 'home/infra/services/web_file_service.dart';
import 'home/presenter/home_page.dart';
import 'home/presenter/stores/file_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => FilePicker.platform),
    PlatformBind.factory(web: (i) => WebFileService(i()), orElse: (i) => DesktopFileService(i(), i())),
    PlatformBind.singleton(web: (i) => WebWindowService(), orElse: (i) => DesktopWindowService()),
    PlatformBind.lazySingleton(web: (i) => WebPlatformFileMapper(), orElse: (i) => DesktopPlatformFileMapper()),
    Bind.factory<LoadJson>((i) => LoadJsonImpl(i())),
    Bind.factory<ReadJson>((i) => ReadJsonImpl(i())),
    Bind.factory<SaveJson>((i) => SaveJsonImpl(i())),
    Bind.factory<DeleteJson>((i) => DeleteJsonImpl(i())),
    Bind.lazySingleton((i) => FileStore(i(), i(), i(), i(), i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const HomePage()),
  ];
}
