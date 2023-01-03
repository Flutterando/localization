import 'package:fluent_ui/fluent_ui.dart';
import 'package:localization/localization.dart';

import 'select_folder_button.dart';

class InitialWidget extends StatelessWidget {
  const InitialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'select-files-initial-text'.i18n(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 18),
            SelectFolderButton(text: 'select-files'.i18n(), textSize: 18),
          ],
        ),
      ),
    );
  }
}
