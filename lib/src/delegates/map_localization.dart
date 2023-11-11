
import 'package:flutter/material.dart';
import 'package:localization/src/localization_service.dart';

class MapLocalization extends LocalizationsDelegate {
  Map<Locale, Map<String, dynamic>> translations = {};
  bool showDebugPrintMode = true;
  MapLocalization._();

  static final delegate = MapLocalization._();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<dynamic> load(Locale locale) async {
    LocalizationService.instance.showDebugPrintMode = showDebugPrintMode;
    LocalizationService.instance.changeLanguageFromMap(locale, translations[locale] ?? {});
  }

  @override
  bool shouldReload(MapLocalization old) => false;
}
