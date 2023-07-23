import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_preferences2.dart';

class ThemeProvider2 with ChangeNotifier {
  bool _isDark = false;
  ThemePreferences2 _preferences = ThemePreferences2();
  bool get isDark => _isDark;

  ThemeProvider2() {
    _isDark = false;
    _preferences = ThemePreferences2();
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
