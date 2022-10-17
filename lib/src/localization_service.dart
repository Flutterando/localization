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

  final _sentences = <String, dynamic>{};

  Future changeLanguage(Locale locale, List<String> directories) async {
    clearSentences();
    for (var directory in directories) {
      await _changeLanguage(locale, directory);
    }
  }

  Future _changeLanguage(Locale locale, String directory) async {
    late String data;
    final selectedLanguage = locale.toString();
    if (directory.endsWith('/')) {
      directory = directory.substring(0, directory.length - 1);
    }
    final jsonFile = '$directory/$selectedLanguage.json';

    data = await rootBundle.loadString(jsonFile);
    ColoredPrint.log('Loaded $jsonFile');

    late Map<String, dynamic> _result;

    try {
      _result = json.decode(data);
    } catch (e) {
      ColoredPrint.error(e.toString());
      _result = {};
    }

    for (var entry in _result.entries) {
      if (_sentences.containsKey(entry.key)) {
        ColoredPrint.warning('Duplicated Key: \"${entry.key}\" Path: \"$locale\"');
      }
      _sentences[entry.key] = entry.value;
    }
  }

  @visibleForTesting
  void addSentence(String key, dynamic value) {
    _sentences[key] = value;
  }

  String read(
    String key,
    List<String> arguments, {
    List<bool>? conditions,
  }) {
    List<String> keys = key.split('.');
    var value = keys.fold(_sentences, (_value, _key) {
      if (_value is Map) {
        return _value[_key] ?? _key;
      }
      return _value.toString();
    });
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

    if (conditions == null || conditions.length == 0) {
      ColoredPrint.error('Existe condicionais configurada na String mas não foi passado nenhum por parametro.');
      return value;
    }
    if (matchers.length != conditions.length) {
      ColoredPrint.error('A Quantidade de condicionais configurada na chave não condiz com os parametros.');
      return value;
    }

    for (var matcher in matchers) {
      for (var i = 1; i <= matcher.groupCount; i++) {
        value = _replaceConditions(matchers, conditions, value);
        final finded = matcher.group(i);
        if (finded == null) {
          continue;
        }
      }
    }

    return value;
  }

  Iterable<RegExpMatch> _getConditionMatch(String text) {
    String pattern = r"%b\{(\s*?.*?)*?\}";
    RegExp regExp = new RegExp(
      pattern,
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(text)) {
      var matches = regExp.allMatches(text);
      return matches;
    }

    return [];
  }

  String _replaceConditions(Iterable<RegExpMatch> matches, List<bool> plurals, String text) {
    var newText = text;
    int i = 0;

    for (var item in matches) {
      var replaced = item.group(0) ?? '';

      RegExp regCondition = new RegExp(
        r'(?<=\{)(.*?)(?=\})',
        caseSensitive: false,
        multiLine: false,
      );
      var e = regCondition.stringMatch(replaced)?.split(':');
      var n = plurals[i] ? e![0] : e![1];

      newText = newText.replaceAll(replaced, n);

      i++;
    }

    return newText;
  }

  String replaceArguments(String value, List<String> arguments) {
    final regExp = RegExp(r'(\%s\d?)');
    final matchers = regExp.allMatches(value);
    var argsCount = 0;

    for (var matcher in matchers) {
      for (var i = 1; i <= matcher.groupCount; i++) {
        final finded = matcher.group(i);
        if (finded == null) {
          continue;
        }

        if (finded == '%s') {
          value = value.replaceFirst('%s', arguments[argsCount]);
          argsCount++;
          continue;
        }

        var extractedId = int.tryParse(finded.replaceFirst('%s', ''));
        if (extractedId == null) {
          continue;
        }

        if (extractedId >= arguments.length) {
          continue;
        }

        value = value.replaceFirst(finded, arguments[extractedId]);
      }
    }

    return value;
  }

  void clearSentences() {
    _sentences.clear();
  }
}
