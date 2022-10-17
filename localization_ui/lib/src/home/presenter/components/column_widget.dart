import 'package:fluent_ui/fluent_ui.dart';

class ColumnWidget extends StatefulWidget {
  final String languageName;
  final void Function()? onRemoveLanguage;

  const ColumnWidget({Key? key, required this.languageName, this.onRemoveLanguage}) : super(key: key);

  @override
  _ColumnWidgetState createState() => _ColumnWidgetState();
}

class _ColumnWidgetState extends State<ColumnWidget> {
  var _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() {
          _isHover = true;
        });
      },
      onExit: (e) {
        setState(() {
          _isHover = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.languageName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: !_isHover
                ? null
                : Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                          icon: Icon(
                            FluentIcons.remove_filter,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            widget.onRemoveLanguage?.call();
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
