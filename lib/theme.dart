import 'package:flutter/material.dart';

// Definiere alle Farben, die du verwenden möchtest
class AppColors {
  static const Color primaryColor = Color(0xFFFAE1D9); // Primärfarbe
  static const Color secondaryColor = Color(0xFFB2DFDB); // Sekundärfarbe
  static const Color accentColor = Color(0xFF8D6E63); // Akzentfarbe
  static const Color appBarColor = Color(0xFFFCEDE9); // Farbe für die AppBar
  static const Color buttonColor = Color(0xB49EF8ED); // Farbe für Buttons
}

// Definiere die Textstile (z.B. für Titel, Body-Text, etc.)
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold, // Verwende das eingebaute FontWeight
    color: AppColors.accentColor, // Verwende die definierte Primärfarbe
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: Colors.black, // Standardfarbe für Text
  );

  // Mark this as const to avoid the warning
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600, // Verwende das eingebaute FontWeight
    color: Colors.white, // Farbe des Textes auf Buttons
  );
}

// Definiere das allgemeine Theme der App
ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.accentColor, // Akzentfarbe für hervorgehobene UI-Elemente
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.appBarColor, // Hintergrundfarbe der AppBar
    titleTextStyle: AppTextStyles.heading, // Stil für den AppBar-Titel
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonColor, // Hintergrundfarbe des Buttons
      textStyle: AppTextStyles.button, // Textstil des Buttons
    ),
  ),
  textTheme: const TextTheme( // Marking TextTheme as const
    titleLarge: AppTextStyles.heading, // Überschriftstil
    bodyMedium: AppTextStyles.body, // Standardstil für Fließtext
  ),
);
