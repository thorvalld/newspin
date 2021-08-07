import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/UIThemes.dart';
import 'pages/newsfeed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: UIThemes.lightTheme,
          darkTheme: UIThemes.darkTheme,
          home: Newsfeed(),
        );
      });
}
