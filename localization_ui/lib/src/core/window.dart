import 'package:window_size/window_size.dart' as window_size;

abstract class WindowService {
  void setWindowTitle(String title);
  void concatTextWithAppName(String value);
}

class DesktopWindowService implements WindowService {
  final _appName = 'Localization UI';

  DesktopWindowService() {
    setWindowTitle(_appName);
  }

  @override
  void setWindowTitle(String title) {
    window_size.setWindowTitle(title);
  }

  @override
  void concatTextWithAppName(String value) {
    window_size.setWindowTitle(_appName + ' - ' + value);
  }
}

class WebWindowService implements WindowService {
  @override
  void concatTextWithAppName(String value) {}

  @override
  void setWindowTitle(String title) {}
}
