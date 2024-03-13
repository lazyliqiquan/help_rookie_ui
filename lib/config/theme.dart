import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart' as origin;

class AppTheme extends ChangeNotifier {
  AccentColor? _color;

  AccentColor get color => _color ?? Colors.purple;

  // AccentColor.swatch(const <String, Color>{
  //   'darkest': origin.Colors.black,
  //   'darker': origin.Colors.black87,
  //   'dark': origin.Colors.black54,
  //   'normal': origin.Colors.black45,
  //   'light': origin.Colors.black38,
  //   'lighter': origin.Colors.black26,
  //   'lightest': origin.Colors.black12,
  // });

  set color(AccentColor color) {
    _color = color;

    notifyListeners();
  }

  Locale? _locale;

  Locale? get locale => _locale ?? const Locale('en');

  set locale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}
