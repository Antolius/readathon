import 'package:flutter/material.dart';
import 'package:readathon/app_sections.dart';

class ReadathonTheme {
  static final Map<AppSection, Color> COLORS = {
    AppSection.BOOKS: Colors.amber,
    AppSection.GOALS: Colors.deepOrange,
    AppSection.STATS: Colors.teal,
  };

  static final Map<AppSection, ThemeData> THEMES = {
    AppSection.BOOKS: _themeFor(COLORS[AppSection.BOOKS]),
    AppSection.GOALS: _themeFor(COLORS[AppSection.GOALS]),
    AppSection.STATS: _themeFor(COLORS[AppSection.STATS]),
  };

  static _themeFor(Color swatch) => new ThemeData(
        brightness: Brightness.light,
        primarySwatch: swatch,
      );
}
