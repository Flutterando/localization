import 'package:fluent_ui/fluent_ui.dart';

class KeyCellWidget extends StatefulWidget {
  final String keyName;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final void Function()? onEditKey;
  final void Function()? onDeleteKey;
  const KeyCellWidget({
    Key? key,
    required this.keyName,
    this.onLongPress,
    this.onTap,
    this.onEditKey,
    this.onDeleteKey,
  }) : super(key: key);

  @override
  _KeyCellWidgetState createState() => _KeyCellWidgetState();
}

class _KeyCellWidgetState extends State<KeyCellWidget> {
  bool _isHover = false;

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
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.keyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: !_isHover
                      ? Container()
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                    iconButtonMode: IconButtonMode.small,
                                    style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                                    icon: Icon(
                                      FluentIcons.remove,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    onPressed: widget.onDeleteKey,
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                    iconButtonMode: IconButtonMode.small,
                                    style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                                    icon: Icon(
                                      FluentIcons.edit,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    onPressed: widget.onEditKey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
