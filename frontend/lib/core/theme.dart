import 'package:flutter/material.dart';

// TODO: Define corporate color palette and typography.
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );
}