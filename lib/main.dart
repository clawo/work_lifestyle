import 'package:flutter/material.dart';
import 'package:work_lifestyle/Database/user_database.dart'; // Import der SQLite-Datenbank
import 'welcome_page.dart'; // Import der WelcomePage
import 'sitting_page.dart'; // Import der SittingPage oder andere Zielseiten

class AppColors {
  static const Color primaryColor = Color(0xFFFAE1D9); // Primärfarbe
  static const Color secondaryColor = Color(0xFFB2DFDB); // Sekundärfarbe
  static const Color accentColor = Color(0xFF8D6E63); // Akzentfarbe
  static const Color appBarColor = Color(0xFFFCEDE9); // Farbe für die AppBar
  static const Color buttonColor = Color(0xFF4CAF50); // Farbe für Buttons
}

// Definiere das allgemeine Theme der App
ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.accentColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.appBarColor,
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Lifestyle',
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final UserDatabase _dbHelper = UserDatabase.instance; // Instanz der Datenbank-Hilfe

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Login-Status über die SQLite-Datenbank prüfen
  Future<void> _checkLoginStatus() async {
    // Hier kannst du den Benutzernamen aus der Datenbank laden
    Map<String, dynamic>? user = await _dbHelper.loadUser("username"); // Ersetze "username" mit dem tatsächlichen Benutzernamen
    bool isLoggedIn = user != null;

    // Navigiere basierend auf dem Login-Status
    if (mounted) { // Prüfe, ob das Widget noch im Baum ist
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SittingPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
