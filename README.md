<a name="readme-top"></a>


<h1 align="center">Localization - Package to simplify in-app translation.</h1>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://pub.dev/packages/localization">
    <img src="readme_assets/img/logo.png" alt="Logo" width="180">
  </a>

  <p align="center">
    A Simple and Clean approach to Snackbars, Dialogs, ModalSheets and more in a single provider.
    <br />
    <a href="https://pub.dev/documentation/localization/latest/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <!-- <a href="https://link para o demo">View Demo</a> -->
    ·
    <a href="https://github.com/davidsdearaujo/localization/issues">Report Bug</a>
    ·
    <a href="https://github.com/davidsdearaujo/localization/issues">Request Feature</a>
  </p>

<br>


<!--  SHIELDS  ---->

[![Version](https://img.shields.io/pub/v/localization?style=plastic)](https://pub.dev/packages/localization)
[![Pub Points](https://img.shields.io/pub/points/localization?label=pub%20points&style=plastic)](https://pub.dev/packages/localization/score)
[![Flutterando Analysis](https://img.shields.io/badge/style-flutterando__analysis-blueviolet?style=plastic)](https://pub.dev/packages/flutterando_analysis/)

[![Pub Publisher](https://img.shields.io/pub/publisher/localization?style=plastic)](https://pub.dev/publishers/flutterando.com.br/packages)
</div>


<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#sponsors">Sponsors</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#how-to-use">How to Use</a>
      <ol><li><a href ="#localizationui">Localization-Ui</a></li></ol> 
    </li>
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<br>

<!-- ABOUT THE PROJECT -->
## About The Project


<!-- PROJECT EXAMPLE (IMAGE) -->



<!-- PROJECT DESCRIPTION -->

Localization é um pacote Dart que visa simplificar e manter uma abordagem limpa ao implementar uma novo formato
Para oferecer suporte a vários idiomas em seu aplicativo Flutter, de um modo simples. Deixando-lhe internalizado, á várias “linguagens”.

<i> This project is distributed under the MIT License. See `LICENSE.txt` for more information.</i>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SPONSORS -->
## Sponsors

<a href="https://fteam.dev">
    <img src="readme_assets/img/sponsor-logo.png" alt="Logo" width="120">
  </a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<br>


<!-- GETTING STARTED -->
## Getting Started
<a href"getting-started"></a>
Use the **Localization** package together with **flutter_localization.

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

    return MaterialApp(
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // delegate from localization package.
        LocalJsonLocalization.delegate,
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

<br>


## How to Use

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
<br>
## Localization UI

<br>
<a href="#localizationui">
<Center>
<img src="readme_assets/img/localizationui.png" alt="Localization package working gif" >
</Center>
</a>
<br>

We have an application to help you configure your translation keys.
The project is also open-source, so be fine if you want to help it evolve!

[Download now](https://github.com/Flutterando/localization/releases)
<br>
**THAT`S IT!
<p align="right">(<a href="#readme-top">back to top</a>)</p>




<!-- FEATURES -->
## Features

- ✅ Snackbars
- ✅ Dialog
- ✅ BottomSheet
- ✅ ModalBottomSheet
- ✅ Overlay 

Right now this package has concluded all his intended features. If you have any suggestions or find something to report, see below how to contribute to it. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing
 
<!-- 🚧 [Contributing Guidelines]() - _Work in Progress_ 🚧 -->

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the appropriate tag. 
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Remember to include a tag, and to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and [Semantic Versioning](https://semver.org/) when uploading your commit and/or creating the issue. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Flutterando Community
- [Discord](https://discord.gg/qNBDHNARja)
- [Telegram](https://t.me/flutterando)
- [Website](https://www.flutterando.com.br)
- [Youtube Channel](https://www.youtube.com.br/flutterando)
- [Other useful links](https://linktr.ee/flutterando)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements 

Thank you to all the people who contributed to this project, whitout you this project would not be here today.

<a href="https://github.com/Flutterando/localization/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterando/localization" />
</a>
<!-- Bot para Lista de contribuidores - https://allcontributors.org/  -->
<!-- Opção (utilizada no momento): https://contrib.rocks/preview?repo=flutterando%2Fasuka -->


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MANTAINED BY -->
## Maintaned by

<br>

<p align="center">
  <a href="https://www.flutterando.com.br">
    <img width="110px" src="readme_assets/img/logo-flutterando.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://www.flutterando.com.br">Flutterando</a>.
  </p>
</p>






<!-----------------------------Divisão---------------------------------------->


<!---

# Localization

Package to simplify in-app translation.
## Install

Use the **Localization** package together with **flutter_localization.

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

    return MaterialApp(
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // delegate from localization package.
        LocalJsonLocalization.delegate,
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
**
**THAT`S IT!


// add settings subtitutulo 
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

![localization ui](https://github.com/Flutterando/localization/blob/master/localization-ui.png)

We have an application to help you configure your translation keys.
The project is also open-source, so be fine if you want to help it evolve!

[Download now](https://github.com/Flutterando/localization/releases)

## Features and bugs

The Segmented State Standard is constantly growing.
Let us know what you think of all this.
If you agree, give a Star in that repository representing that you are signing and consenting to the proposed standard.

## Questions and Problems

The **issues** channel is open for questions, to report problems and suggestions, do not hesitate to use this communication channel.

> **LET'S BE REFERENCES TOGETHER**
