import 'package:flutter/material.dart';
import 'activity_page.dart'; // Relativer Import zur ActivityPage
import 'package:work_lifestyle/Database/user_database.dart'; // Relativer Import zur UserDatabase

class PersonalDetailsPage extends StatefulWidget {
  final String email; // E-Mail als Parameter

  const PersonalDetailsPage({super.key, required this.email});

  @override
  PersonalDetailsPageState createState() => PersonalDetailsPageState();
}

class PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final UserDatabase _database = UserDatabase.instance; // Instanziiere die Datenbank

  Future<void> _next() async {
    final name = _nameController.text;
    final ageString = _ageController.text; // Alter als String
    final weight = _weightController.text;

    // Versuche, das Alter in einen Integer umzuwandeln
    int? age;
    if (ageString.isNotEmpty) {
      age = int.tryParse(ageString); // Konvertiere String zu int
    }

    // Überprüfe, ob die Umwandlung erfolgreich war
    if (age == null) {
      // Handle den Fehler (z.B. zeige eine Fehlermeldung an)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib ein gültiges Alter ein.')),
      );
      return; // Verlasse die Methode, wenn die Eingabe ungültig ist
    }

    // Speichere den Namen, das Alter und das Gewicht in der Datenbank
    await _database.saveUserDetails(widget.email, name, age, weight);

    // Leite den Benutzer zur ActivityPage weiter
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityPage(email: widget.email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _next,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
