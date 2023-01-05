import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'src/app_module.dart';
import 'src/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) await Window.initialize();

  runApp(ModularApp(
    child: const MyApp(),
    module: AppModule(),
  ));

  if (!kIsWeb) {
    const initialSize = Size(1127.0, 600.0);
    await DesktopWindow.setMinWindowSize(initialSize);

    if (Platform.isWindows) {
      await Window.setEffect(
        dark: true,
        effect: WindowEffect.mica,
        color: const Color(0xCC222222),
      );
    }

    if (Platform.isMacOS) {
      await Window.setEffect(
        effect: WindowEffect.sidebar,
        dark: true,
        color: const Color(0xCC222222),
      );
    }
  }
}
