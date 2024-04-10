# Localization

Package to simplify in-app translation.
## Install

Use the **Localization** package together with **flutter_localization**.

Add in your `pubspec`:
```yaml
dependencies:
  flutter_localizations: 
    sdk: flutter
  localization: <last-version>

flutter:

  # json files directory
  assets:
    - lib/i18n/
```

Now, add the delegate in **MaterialApp** or **CupertinoApp** and define a path where the translation json files will be:
```dart
 @override
  Widget build(BuildContext context) {
    // set json file directory
    // default value is ['lib/i18n']
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    
    //or set a map of translations
    MapLocalization.delegate.translations = {
      Locale('en', 'US'): {
        'welcome-text': 'This text is in english',
      },
      Locale('es', 'ES'): {
        'welcome-text': 'Este texto esta en español',
      },
      Locale('pt', 'BR'): {
        'welcome-text': 'Este texto está em português',
      },
    };

    return MaterialApp(
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        
        // delegate from localization package.
        //json-file
        LocalJsonLocalization.delegate,
        //or map
        MapLocalization.delegate,
      ],
      home: HomePage(),
    );
  }
```

## Json files

The json file pattern must have the name of the locale and its content must be a json of key and value ONLY.
Create the files in the directory configured (`LocalJsonLocalization.delegate.directories`):

```
lib/i18n/en_US.json
lib/i18n/es_ES.json
lib/i18n/pt_BR.json
```

See an example of a translation json file:

**en_US.json**
```json
{
  "welcome-text": "This text is in english"
}
```
**es_ES.json**
```json
{
  "welcome-text": "Este texto esta en español"
}
```
**pt_BR.json**
```json
{
  "welcome-text": "Este texto está em português"
}
```

## Using

For convenience, the **i18n()** method has been added to the String class via extension.
So just add the translation json file key as string and use **i18n()** method to bring up the translation.

```dart
String text = 'welcome-text'.i18n();
print(text) // prints 'This text is in english'
```

We can also work with arguments for translation. Use **%s** notion:
```json
{
  "welcome-text": "Welcome, %s"
}
```
```dart
String text = 'welcome-text'.i18n(['Peter']);
print(text); // Welcome, Peter

```
The **%s** notation can also be retrieved positionally. Just use **%s0, %s1, %s2**...

You could plularization your Strings. Use **%b{true:false}** notion, where left is a string value when condition is true and on the right is a value when condition is false:
```json
{
  "person-text": "Welcome, %b{people:person}"
}
```
```dart
final count = 2;
String text = 'person-text'.i18n(
        [], //args is a required positional parameter, if you don't gave a %s notation give a empty list []
        conditions: [count > 1]);
print(text); // Welcome, people
```

**THAT`S IT!**

## Additional settings

After installation, the **Localization** package is fully integrated into Flutter and can reflect changes made natively by the SDK.
Here are some examples of configurations that we will be able to do directly in **MaterialApp** or **CupertinoApp**.

### Add supported languages

This setting is important to tell Flutter which languages your app is prepared to work with. We can do this by simply adding the Locale in the **supportedLocales** property:
```dart
return MaterialApp(
  supportedLocales: [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'BR'),
  ],
  ...
);
```

### Locale resolution

Often we will not have to make some decisions about what to do when the device language is not supported by our app or work with a different translation for different countries (eg pt_BR(Brazil) and pt_PT(Portugal).
For these and other decisions we can use the dsdsk property to create a resolution strategy:

```dart
return MaterialApp(
  localeResolutionCallback: (locale, supportedLocales) {
      if (supportedLocales.contains(locale)) {
        return locale;
      }

      // define pt_BR as default when de language code is 'pt'
      if (locale?.languageCode == 'pt') {
        return Locale('pt', 'BR');
      }

      // default language
      return Locale('en', 'US');
  },
  ...
);
```

## Localization UI

[Web version](https://localization.codemagic.app) | [Download now](https://github.com/Flutterando/localization/releases)

We have an application to help you configure your translation keys.
The project is also open-source, so be fine if you want to help it evolve!

![localization ui](https://user-images.githubusercontent.com/16373553/210827297-0f5bcc7a-e950-40b5-bd91-dda61a2bda8d.png)

## Features and bugs

Localization package is constantly growing.
Let us know what you think of all this.
If you agree, give a Star in that repository representing that you are signing and consenting to the proposed standard.

## Questions and Problems

The **issues** channel is open for questions, to report problems and suggestions, do not hesitate to use this communication channel.

> **LET'S BE REFERENCES TOGETHER**
