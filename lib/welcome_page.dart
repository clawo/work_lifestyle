// welcome_page.dart
import 'package:flutter/material.dart';
import 'package:work_lifestyle/Database/user_database.dart'; // Importiere UserDatabase
import 'register_page.dart';
import 'sitting_page.dart' as sitting; // Alias für sitting_page.dart
import 'standing_page.dart' as standing; // Alias für standing_page.dart
import 'mixed_page.dart' as mixed; // Alias für mixed_page.dart

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _emailController.text;
    final token = _passwordController.text;

    // Lade Benutzerdaten aus der Datenbank
    final user = await UserDatabase.instance.loadUser(username);

    if (user != null && user['token'] == token) {
      String employmentType = user['employmentType'] ?? 'default';

      // Bestimme die nächste Seite basierend auf dem Employment Type
      Widget nextPage;

      switch (employmentType) {
        case 'sitting':
          nextPage = const sitting.SittingPage();
          break;
        case 'standing':
          nextPage = const standing.StandingPage();
          break;
        case 'mixed':
          nextPage = const mixed.MixedPage();
          break;
        default:
          nextPage = const Scaffold(
            body: Center(child: Text('Unexpected state')),
          );
          break;
      }

      // Navigiere zur entsprechenden Seite
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      }
    } else {
      // Fehlerfall: Benutzerdaten nicht korrekt
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login. Please try again.')),
        );
      }
    }
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _goToRegisterPage,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
