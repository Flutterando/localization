import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/src/localization_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalizationService.instance.showDebugPrintMode = false;
  });

  tearDown(() {
    LocalizationService.instance.clearSentences();
  });

  group('Read', () {
    test('Read', () {
      LocalizationService.instance.addSentence('full-name', 'Jacob Moura');
      final value = LocalizationService.instance.read('full-name', []);
      expect(value, 'Jacob Moura');
    });

    test('Read with 1 arguments', () {
      LocalizationService.instance.addSentence('full-name', 'Jacob %s');
      var value = LocalizationService.instance.read('full-name', ['Araujo']);
      expect(value, 'Jacob Araujo');

      value = LocalizationService.instance.read('full-name', ['Moura']);
      expect(value, 'Jacob Moura');
    });

    test('Read with 2 arguments', () {
      LocalizationService.instance.addSentence('full-name-complete', 'Jacob %s %s');

      var value = LocalizationService.instance.read('full-name-complete', ['Araujo', 'Moura']);
      expect(value, 'Jacob Araujo Moura');
    });

    test('Read with positional arguments', () {
      LocalizationService.instance.addSentence('full-name-complete-positional', 'Jacob %s1 %s0');

      var value = LocalizationService.instance.read('full-name-complete-positional', ['Araujo', 'Moura']);
      expect(value, 'Jacob Moura Araujo');
    });

    test('Read with positional arguments out range', () {
      LocalizationService.instance.addSentence('full-name-complete-positional', 'Jacob %s0 %s1 %s9');

      var value = LocalizationService.instance.read('full-name-complete-positional', ['Araujo', 'Moura']);
      expect(value, 'Jacob Araujo Moura %s9');
    });

    test('Read with false condition arguments', () {
      var count = 1;
      LocalizationService.instance.addSentence('person-label', '%s %b{people:person}');

      var value = LocalizationService.instance.read(
        'person-label',
        [count.toString()],
        conditions: [count > 1],
      );
      expect(value, '1 person');
    });
    test('Read with true condition arguments', () {
      final count = 2;
      LocalizationService.instance.addSentence('person-label', '%s %b{people:person}');

      var value = LocalizationService.instance.read(
        'person-label',
        [count.toString()],
        conditions: [count > 1],
      );
      expect(value, '2 people');
    });

    test('Read with hierarchy', () {
      LocalizationService.instance.addSentence('example', {'title': 'Hierarchy Example'});
      final value = LocalizationService.instance.read('example.title', []);
      expect(value, 'Hierarchy Example');
    });
  });

  group('load translations', () {
    test('load en_US - json file', () async {
      await LocalizationService.instance.changeLanguageFromDirectories(Locale('en', 'US'), ['test/assets/lang']);
      var value = LocalizationService.instance.read('login-label', []);
      expect(value, 'User');
      value = LocalizationService.instance.read('home-title', ['Flutterando']);
      expect(value, 'Localization Test - Flutterando');
    });

    test('load en_US - map', () async {
      Map<String, dynamic> translation = {
        "home-title": "Localization Test - %s",
        "welcome": "Welcome, Today is %s",
        "login-label": "User",
        "password-label": "Password",
        "change-value": "Mudar para português"
      }
      ;
      await LocalizationService.instance.changeLanguageFromMap(Locale('en', 'US'), translation);
      var value = LocalizationService.instance.read('login-label', []);
      expect(value, 'User');
      value = LocalizationService.instance.read('home-title', ['Flutterando']);
      expect(value, 'Localization Test - Flutterando');
    });
  });
}
