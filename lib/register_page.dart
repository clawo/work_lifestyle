// register_page.dart
import 'package:flutter/material.dart';
import 'package:work_lifestyle/Database/user_database.dart';
import 'personal_details_page.dart'; // Importiere PersonalDetailsPage

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Überprüfe auf leere Felder
      print('Email oder Passwort darf nicht leer sein.');
      return;
    }

    try {
      // Speichern des Benutzers in der Datenbank
      await UserDatabase.instance.saveLogin(
        _emailController.text,
        _passwordController.text,
      );

      // Navigiere zur PersonalDetailsPage nach erfolgreicher Registrierung
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalDetailsPage(email: _emailController.text),
          ),
        );
      }
    } catch (e) {
      print('Fehler beim Registrieren: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              onPressed: _register,
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
