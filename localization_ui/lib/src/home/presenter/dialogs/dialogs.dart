import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:system_theme/system_theme.dart';

import '../../domain/entities/language_file.dart';
import '../formatters/remove_space.dart';
import '../stores/file_store.dart';

Future dialogAddKeyName(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      var key = '';
      return ContentDialog(
        title: Text('key-name'.i18n()),
        content: TextBox(
          textInputAction: TextInputAction.send,
          onSubmitted: (_) {
            if (key.isEmpty) {
              return;
            }
            context.read<FileStore>().addNewKey(key);
            Navigator.of(context).pop();
          },
          inputFormatters: [RemoveSpace()],
          onChanged: (value) => key = value,
          placeholder: 'key'.i18n(),
        ),
        actions: [
          Button(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.i18n()),
          ),
          Button(
            onPressed: () {
              if (key.isEmpty) {
                return;
              }
              context.read<FileStore>().addNewKey(key);
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: ButtonState.all(SystemTheme.accentInstance.accent),
            ),
            child: Text('save'.i18n()),
          )
        ],
      );
    },
  );
}

Future dialogUpdateKeyName(String oldKey, BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      var key = '';
      return ContentDialog(
        title: Text('edit-key'.i18n()),
        content: TextFormBox(
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (text) {
            if (oldKey != key) {
              context.read<FileStore>().editKey(oldKey, key);
            }
            Navigator.of(context).pop();
          },
          inputFormatters: [RemoveSpace()],
          initialValue: oldKey,
          onChanged: (value) => key = value,
          placeholder: 'key'.i18n(),
        ),
        actions: [
          Button(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.i18n()),
          ),
          Button(
            onPressed: () {
              if (oldKey != key) {
                context.read<FileStore>().editKey(oldKey, key);
              }
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: ButtonState.all(SystemTheme.accentInstance.accent),
            ),
            child: Text('save'.i18n()),
          )
        ],
      );
    },
  );
}

Future dialogAddNewLanguage(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      var languageName = '';
      return ContentDialog(
        title: Text('new-language'.i18n()),
        content: TextFormBox(
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (text) {
            context.read<FileStore>().addNewLanguage(languageName);
            Navigator.of(context).pop();
          },
          inputFormatters: [RemoveSpace()],
          onChanged: (value) => languageName = value,
          placeholder: 'en_US...',
        ),
        actions: [
          Button(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.i18n()),
          ),
          Button(
            onPressed: () {
              context.read<FileStore>().addNewLanguage(languageName);
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: ButtonState.all(SystemTheme.accentInstance.accent),
            ),
            child: Text('save'.i18n()),
          )
        ],
      );
    },
  );
}

Future didRemoveLanguageDialog(LanguageFile language, BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return _DialogRemoveLanguageWidget(languageFile: language);
    },
  );
}

class _DialogRemoveLanguageWidget extends StatefulWidget {
  final LanguageFile languageFile;
  const _DialogRemoveLanguageWidget({Key? key, required this.languageFile}) : super(key: key);

  @override
  __DialogRemoveLanguageWidgetState createState() => __DialogRemoveLanguageWidgetState();
}

class __DialogRemoveLanguageWidgetState extends State<_DialogRemoveLanguageWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> countDownAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    countDownAnimation = Tween<double>(begin: 10, end: 0).animate(controller);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('did-remove-language'.i18n([widget.languageFile.nameWithoutExtension])),
      content: Text('action-cannot-be-undone'.i18n()),
      actions: [
        AnimatedBuilder(
          animation: countDownAnimation,
          builder: (context, child) {
            final count = countDownAnimation.value;
            final isDown = count != 0.0;
            return Button(
              onPressed: isDown
                  ? null
                  : () {
                      context.read<FileStore>().removeLanguage(widget.languageFile);
                      Navigator.of(context).pop();
                    },
              style: isDown
                  ? null
                  : ButtonStyle(
                      backgroundColor: ButtonState.all(Colors.red),
                    ),
              child: Text('yes'.i18n() + (isDown ? '(' + count.toInt().toString() + ')' : '')),
            );
          },
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('no'.i18n()),
        )
      ],
    );
  }
}
