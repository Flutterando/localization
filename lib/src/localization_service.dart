import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/colored_print/colored_print.dart';

class LocalizationService {
  static LocalizationService? _instance;
  bool showDebugPrintMode = true;

  static LocalizationService get instance {
    _instance ??= LocalizationService();
    return _instance!;
  }

  final _sentences = <String, String>{};

  Future changeLanguage(Locale locale, List<String> directories) async {
    clearSentences();
    for (final directory in directories) {
      await _changeLanguage(locale, directory);
    }
  }

  Future _changeLanguage(Locale locale, String directory) async {
    late String data;
    final selectedLanguage = locale.toString();
    var newDirectory = directory;
    // var jubileu = '';
    if (newDirectory.endsWith('/')) {
      newDirectory = newDirectory.substring(0, newDirectory.length - 1);
    }
    final jsonFile = '$newDirectory/$selectedLanguage.json';

    data = await rootBundle.loadString(jsonFile);
    ColoredPrint.log('Loaded $jsonFile');

    late Map<String, dynamic> _result;

    try {
      _result = json.decode(data);
    } catch (e) {
      ColoredPrint.error(e.toString());
      _result = {};
    }

    for (final entry in _result.entries) {
      if (_sentences.containsKey(entry.key)) {
        ColoredPrint.warning('Duplicated Key: "${entry.key}" Path: "$locale"');
      }
      _sentences[entry.key] = entry.value.toString();
    }
  }

  @visibleForTesting
  void addSentence(String key, String value) {
    _sentences[key] = value;
  }

  String read(
    String key,
    List<String> arguments, {
    List<bool>? conditions,
  }) {
    if (!_sentences.containsKey(key)) {
      return key;
    }
    var value = _sentences[key]!;
    if (value.contains('%s')) {
      value = replaceArguments(value, arguments);
    }
    if (value.contains('%b')) {
      value = replaceConditions(value, conditions);
    }

    return value;
  }

  String replaceConditions(String value, List<bool>? conditions) {
    final matchers = _getConditionMatch(value);
    var newValue = value;

    if (conditions == null || conditions.isEmpty) {
      ColoredPrint.error('''
Existe condicionais configurada na String mas não foi passado nenhum por parametro.''');
      return newValue;
    }
    if (matchers.length != conditions.length) {
      ColoredPrint.error('''
A Quantidade de condicionais configurada na chave não condiz com os parametros.''');
      return newValue;
    }

    for (final matcher in matchers) {
      for (var i = 1; i <= matcher.groupCount; i++) {
        newValue = _replaceConditions(matchers, conditions, newValue);
        final finded = matcher.group(i);
        if (finded == null) {
          continue;
        }
      }
    }

    return newValue;
  }

  Iterable<RegExpMatch> _getConditionMatch(String text) {
    const pattern = r'%b\{(\s*?.*?)*?\}';
    final regExp = RegExp(
      pattern,
      caseSensitive: false,
    );
    if (regExp.hasMatch(text)) {
      final matches = regExp.allMatches(text);
      return matches;
    }

    return [];
  }

  String _replaceConditions(
    Iterable<RegExpMatch> matches,
    List<bool> plurals,
    String text,
  ) {
    var newText = text;
    var i = 0;

    for (final item in matches) {
      final replaced = item.group(0) ?? '';

      final regCondition = RegExp(
        r'(?<=\{)(.*?)(?=\})',
        caseSensitive: false,
      );
      final e = regCondition.stringMatch(replaced)?.split(':');
      final n = plurals[i] ? e![0] : e![1];

      newText = newText.replaceAll(replaced, n);

      i++;
    }

    return newText;
  }

  String replaceArguments(String value, List<String> arguments) {
    final regExp = RegExp(r'(\%s\d?)');
    final matchers = regExp.allMatches(value);
    var argsCount = 0;
    var newString = value;

    for (final matcher in matchers) {
      for (var i = 1; i <= matcher.groupCount; i++) {
        final finded = matcher.group(i);
        if (finded == null) {
          continue;
        }

        if (finded == '%s') {
          newString = newString.replaceFirst(
            '%s',
            arguments[argsCount],
          );
          argsCount++;
          continue;
        }

        final extractedId = int.tryParse(finded.replaceFirst('%s', ''));
        if (extractedId == null) {
          continue;
        }

        if (extractedId >= arguments.length) {
          continue;
        }

        newString = newString.replaceFirst(finded, arguments[extractedId]);
      }
    }

    return newString;
  }

  void clearSentences() {
    _sentences.clear();
  }
}
