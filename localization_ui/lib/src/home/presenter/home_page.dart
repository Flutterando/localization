import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lazy_data_table_plus/lazy_data_table_plus.dart';
import 'package:localization/localization.dart';
import 'package:localization_ui/src/home/presenter/extensions/file_language_extension.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';
import 'components/column_widget.dart';
import 'components/create_new_key_widget.dart';
import 'components/custom_app_bar.dart';
import 'components/empty_language_widget.dart';
import 'components/file_progress_widget.dart';
import 'components/ideas_pane_widget.dart';
import 'components/initial_widget.dart';
import 'components/key_cell_widget.dart';
import 'dialogs/dialogs.dart';

class SaveIntent extends Intent {}

class UndoIntent extends Intent {}

class RedoIntent extends Intent {}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isIdeasBox = false;
  var _enableAnimationPane = false;

  final searchTextController = TextEditingController(text: '');
  String get _searchText => searchTextController.text;

  @override
  void initState() {
    super.initState();
    final store = context.read<FileStore>();
    store.observer(onError: (error) {
      showSnackbar(
        context,
        Snackbar(content: Text(error.message.i18n())),
      );
    });
  }

  final saveFileKeySet = LogicalKeySet(
    kIsWeb || Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyS,
  );
  final undoFileKeySet = LogicalKeySet(
    kIsWeb || Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyZ,
  );

  final redoFileKeySet = LogicalKeySet(
    kIsWeb || Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.keyZ,
  );

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FileStore>((s) => s.selectState);
    final state = store.state;

    Widget child = Container();

    if (store.isLoading) {
      child = const FileProgressWidget();
    } else if (state is InitFileState) {
      child = const InitialWidget();
    } else if (state is LoadedFileState) {
      final keys = state.keys
          .where(
            (key) {
              if (_searchText.isEmpty || key.contains(_searchText)) {
                return true;
              }

              for (var lang in state.languages) {
                final text = lang.read(key).toLowerCase();
                if (text.contains(_searchText.toLowerCase())) {
                  return true;
                }
              }
              return false;
            },
          )
          .toList()
          .reversed
          .toSet();

      final openedPaneSize = MediaQuery.of(context).size.width - 300;

      child = ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: _enableAnimationPane ? 300 : 0),
            curve: Curves.easeOut,
            onEnd: () {
              setState(() {
                _enableAnimationPane = false;
              });
            },
            width: !_isIdeasBox ? MediaQuery.of(context).size.width : openedPaneSize,
            child: FocusableActionDetector(
              autofocus: true,
              shortcuts: {
                saveFileKeySet: SaveIntent(),
                undoFileKeySet: UndoIntent(),
                redoFileKeySet: RedoIntent(),
              },
              actions: {
                SaveIntent: CallbackAction(onInvoke: (e) {
                  store.saveLanguages();
                  return true;
                }),
                UndoIntent: CallbackAction(onInvoke: (e) {
                  store.undo();
                  return true;
                }),
                RedoIntent: CallbackAction(onInvoke: (e) {
                  store.redo();
                  return true;
                }),
              },
              child: Column(
                children: [
                  CustomAppBar(
                    onNewKeyPressed: () {
                      Future.microtask(() {
                        dialogAddKeyName(context);
                      });
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    searchTextController: searchTextController,
                    onCancelSearch: () {
                      setState(() {
                        searchTextController.text = '';
                      });
                    },
                    onIdeasButtonPressed: () {
                      setState(() {
                        _enableAnimationPane = true;
                        _isIdeasBox = !_isIdeasBox;
                      });
                    },
                    onNewLanguagePressed: () {
                      Future.microtask(() {
                        dialogAddNewLanguage(context);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (state.languages.isEmpty)
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const EmptyLanguageWidget(),
                      ),
                    ),
                  if (state.languages.isNotEmpty)
                    Expanded(
                      child: Builder(builder: (context) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: LazyDataTable(
                            key: ValueKey(store.undoAndRedoCount),
                            tableDimensions: const LazyDataTableDimensions(
                              cellHeight: 89,
                              cellWidth: 300,
                              columnHeaderHeight: 50,
                              rowHeaderWidth: 220,
                            ),
                            tableTheme: LazyDataTableTheme(
                              columnHeaderBorder: Border.all(color: Colors.black.withOpacity(0.38)),
                              rowHeaderBorder: Border.all(color: Colors.black.withOpacity(0.38)),
                              cellBorder: Border.all(color: Colors.black.withOpacity(0.12)),
                              cornerBorder: Border.all(color: Colors.black.withOpacity(0.38)),
                              columnHeaderColor: Colors.black.withOpacity(0.3),
                              rowHeaderColor: Colors.black.withOpacity(0.3),
                              cornerColor: Colors.black.withOpacity(0.3),
                            ),
                            columns: state.languages.length,
                            rows: keys.length,
                            columnHeaderBuilder: (int columnIndex) {
                              final lang = state.languages[columnIndex];
                              return ColumnWidget(
                                languageName: lang.nameWithoutExtension,
                                onRemoveLanguage: () {
                                  didRemoveLanguageDialog(lang, context);
                                },
                              );
                            },
                            rowHeaderBuilder: (int rowIndex) {
                              final key = keys.elementAt(rowIndex);
                              return KeyCellWidget(
                                keyName: key,
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(text: key));
                                  showSnackbar(context, Snackbar(content: Text('clipboard-text'.i18n())));
                                },
                                onEditKey: () {
                                  dialogUpdateKeyName(key, context);
                                },
                                onDeleteKey: () => store.removeKey(key),
                              );
                            },
                            dataCellBuilder: (int rowIndex, int columnIndex) {
                              final key = keys.elementAt(rowIndex);
                              final lang = state.languages[columnIndex];

                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Transform.translate(
                                  offset: const Offset(0, 8),
                                  child: TextFormBox(
                                    maxLines: 3,
                                    key: ValueKey('$key$columnIndex'),
                                    onChanged: (value) {
                                      final langsCopy = state.languages.map((e) => e.copy()).toList();
                                      final langLocal = langsCopy[columnIndex];
                                      langLocal.set(key, value);
                                      store.updateLanguages(langsCopy);
                                    },
                                    initialValue: lang.read(key),
                                  ),
                                ),
                              );
                            },
                            cornerWidget: Center(
                              child: Text(
                                'keys'.i18n(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  if (keys.isEmpty && state.languages.isNotEmpty)
                    const Expanded(
                      child: CreateNewKeyWidget(),
                    )
                ],
              ),
            ),
          ),
          const IdeasPaneWidget(),
        ],
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: NavigationView(
        content: child,
      ),
    );
  }
}
