import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  isPresentSP(String prefKey) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey(prefKey)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fetchThemeSettingsFromSP() async {
    SharedPreferences mSharedPrefs = await SharedPreferences.getInstance();
    try {
      if (isPresentSP('myThemeMode') == false) {
        return false;
      } else {
        var spr = mSharedPrefs.getBool('myThemeMode');
        if (spr != null) {
          if (spr) {
            return true;
          } else if (!spr) {
            return false;
          }
        } else if (spr == null) {
          return false;
        }
      }
      return false;
    } catch (e) {
      print('fetch theme from SP err: ' + e.toString());
      return false;
    }
  }

  themeModeSettings() {
    fetchThemeSettingsFromSP().then((val) {
      if (val == null) {
        return false;
      } else {
        return val;
      }
    });
  }

  ThemeMode themeMode = ThemeMode.light;
  //bool get isDarkMode => themeMode == ThemeMode.dark;

  bool get isDarkMode => themeModeSettings() ?? themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class UIThemes {
  static final darkTheme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
      primaryColor: Colors.grey.shade900,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light());
}
