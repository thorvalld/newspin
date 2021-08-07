import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunipin/constants/UIThemes.dart';

class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value) async {
          SharedPreferences mSharedPrefs =
              await SharedPreferences.getInstance();
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
          mSharedPrefs.setBool('myThemeMode', value);
        });
  }
}
