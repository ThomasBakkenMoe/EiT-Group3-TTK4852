import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class SchemeNotifier extends ChangeNotifier {
  FlexScheme _scheme = FlexScheme.green;
  FlexScheme get scheme => _scheme;

  void setThemeMode(FlexScheme scheme) {
    _scheme = scheme;
    notifyListeners();
  }

  void setThemeModeIndex(int index) {
    _scheme = FlexScheme.values[index];
    notifyListeners();
  }
}
