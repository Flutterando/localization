## [2.2.0-beta.1] 2024-10-23
* Bump Flutter version to 3.22.0 ++;
* Created example importing translation files from a package;
* If the key was not found in any of the translation files, it shows the entire key. Eg: `buttons.subscribe`;


## [2.1.0] 2022-02-03
* Added multiples path files.

## [2.0.0+1] 2022-01-24
Now the **Localization** package is fully integrated into Flutter and can reflect changes made natively by the SDK.

* BREAK CHANGE: Removed packages translation files;
* BREAK CHANGE: `.i18n()` parameters are a positional args now;
* BREAK CHANGE: Removed conditions. After long discussions, we decided that this is a developer responsibility, for example:
```dart
final items = 10;
if(items == 1) return 'title-label-singular'.i18n();
if(items > 1) return 'title-label-plural'.i18n();
```

## [1.1.2-dev.1] 2022-01-13
Added support of translation files just with language, for example `pt.json`;

```dart
await Localization.configuration(showDebugPrintMode: false);
```

## [1.1.1] 2021-11-22
deixar Log ocional, para desativa-lo basta utilizar

```dart
await Localization.configuration(showDebugPrintMode: false);
```

You can set the variable calling the function:
```dart
Localization.setShowDebugPrintMode(false);
```

## [1.1.0] 2021-08-29

* BREAK CHANGE: The parameters from method `'welcome'.i18n(["22/06"])` e `Localization.translate('welcome', ["22/06"])` are named;
* BREAK CHANGE: Use `"welcome".i18n(args: ["22/06"])` ao invés de `"welcome".i18n(["22/06"])`
* BREAK CHANGE: Use `Localization.translate('welcome', args: ["22/06"])` ao invés de `Localization.translate('welcome', ["22/06"])`
### New features
* Adição de possibilidade de usar condicionais utilize o `%b{condicao_verdadeira:condição_falsa}` para configurar as suas traduções
```json
{
	'quantidade':  '%s %b{Resultados:Resultado} %b{encontrados:encontrado}'
}
```
Será necessário na parâmetro `conditions` passar uma lista de Booleanos de forma posicional
```dart
Localization.translate(
	'testeQuantidade',
	args: ['2'],
	conditions: [true, true],
)
```

```dart
'testeQuantidade'.i18n(
	args: ['1'],
	conditions: [false, false],
)
```

## [1.0.0] 2021-07-28

* Use Text("welcome".i18n(args: ["22/06"])), ao inves de Text("welcome".i18n(["22/06"])),
## [1.0.0] 2021-07-28

* Adicionada possibilidade de multiplos diretórios de tradução;

## [0.2.0-nullsafety] 2021-03-01

* Migração Nullsafety;

## [0.1.0] 2020-06-11

* Atualizado README;
* Adicionada automação no [SLIDY CLI](https://pub.dev/packages/slidy);

## [0.0.2] 2020-02-25

* Initial release.
