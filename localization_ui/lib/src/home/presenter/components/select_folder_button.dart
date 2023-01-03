import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization/localization.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';

class SelectFolderButton extends StatefulWidget {
  final String text;
  final double? textSize;
  const SelectFolderButton({Key? key, this.textSize, required this.text}) : super(key: key);

  @override
  _SelectFolderButtonState createState() => _SelectFolderButtonState();
}

class _SelectFolderButtonState extends State<SelectFolderButton> {
  @override
  Widget build(BuildContext context) {
    final store = context.read<FileStore>();
    return TripleBuilder(
      store: store,
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Button(
            onPressed: store.isLoading ? null : store.loadFiles,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FluentIcons.folder_horizontal),
                const SizedBox(width: 9),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.textSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
