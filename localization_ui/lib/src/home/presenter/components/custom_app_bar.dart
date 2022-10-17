import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';

import 'select_folder_button.dart';

class CustomAppBar extends StatelessWidget {
  final void Function()? onNewKeyPressed;
  final void Function()? onNewLanguagePressed;
  final void Function()? onIdeasButtonPressed;
  final void Function()? onCancelSearch;
  final void Function(String value)? onChanged;
  final TextEditingController searchTextController;
  const CustomAppBar({
    Key? key,
    this.onNewKeyPressed,
    required this.searchTextController,
    this.onChanged,
    this.onCancelSearch,
    this.onIdeasButtonPressed,
    this.onNewLanguagePressed,
  }) : super(key: key);

  String get _searchText => searchTextController.text;

  @override
  Widget build(BuildContext context) {
    final store = context.read<FileStore>();
    const separedWidget = SizedBox(width: 12);

    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      color: Colors.black.withOpacity(0.38),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          MouseRegion(
            cursor: store.isSaved ? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: Button(
              onPressed: store.isSaved ? null : store.saveLanguages,
              child: Row(
                children: [
                  const Icon(FluentIcons.save),
                  const SizedBox(width: 9),
                  Text('save'.i18n()),
                ],
              ),
            ),
          ),
          separedWidget,
          const SelectFolderButton(),
          separedWidget,
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropDownButton(
              leading: const Icon(FluentIcons.translate),
              title: const Text('New'),
              items: [
                MenuFlyoutItem(
                  text: Text('new-key'.i18n()),
                  onPressed: () {
                    onNewKeyPressed?.call();
                  },
                ),
                MenuFlyoutItem(
                  text: Text('new-language'.i18n()),
                  onPressed: () {
                    onNewLanguagePressed?.call();
                  },
                ),
              ],
            ),
          ),
          separedWidget,
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
              onPressed: !store.canUndo() ? null : store.undo,
              child: const Icon(FluentIcons.undo),
            ),
          ),
          const SizedBox(width: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
              onPressed: !store.canRedo() ? null : store.redo,
              child: const Icon(FluentIcons.redo),
            ),
          ),
          separedWidget,
          const Spacer(),
          Expanded(
            flex: 5,
            child: TextBox(
              controller: searchTextController,
              placeholder: 'search'.i18n() + '...',
              suffix: _searchText.isEmpty
                  ? null
                  : MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: onCancelSearch,
                      ),
                    ),
              onChanged: onChanged,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(FluentIcons.lightbulb),
              ),
              onPressed: onIdeasButtonPressed,
            ),
          ),
        ],
      ),
    );
  }
}
