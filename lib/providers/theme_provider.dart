import 'package:digicon/constants/keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = getBoolAsync(
    Constants.isDarkMode,
    defaultValue: ThemeMode.system != ThemeMode.dark,
  );
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode
          ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 252, 101, 82),
              brightness: Brightness.dark,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.grey[800],
              contentTextStyle: TextStyle(color: Colors.white),
              actionTextColor: Colors.tealAccent,
            ),
            dialogTheme: DialogTheme(
              // titleTextStyle: TextStyle(color: Colors.white),
              // contentTextStyle: TextStyle(color: Colors.white),
            ),
          )
          : ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 252, 101, 82),
            ),
            dialogTheme: DialogTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black),
              contentTextStyle: TextStyle(color: Colors.black),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.grey[900],
              contentTextStyle: TextStyle(color: Colors.white),
              actionTextColor: Colors.tealAccent,
            ),
          );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    setValue(Constants.isDarkMode, _isDarkMode);
    notifyListeners();
  }
}
