import 'package:flutter/material.dart';
import 'package:work_lifestyle/Database/user_database.dart';
import 'sitting_page.dart';
import 'standing_page.dart';
import 'mixed_page.dart';

class AssessmentPage extends StatefulWidget {
  final String email; // E-Mail-Parameter hinzufügen

  const AssessmentPage({super.key, required this.email}); // E-Mail als Pflichtparameter

  @override
  AssessmentPageState createState() => AssessmentPageState();
}

class AssessmentPageState extends State<AssessmentPage> {
  String _selectedOption = 'sitting';

  Future<void> _saveSelection() async {
    String employmentType = _selectedOption;

    // Speichern der Auswahl in der Datenbank für den aktuellen Benutzer
    await UserDatabase.instance.saveEmploymentType(widget.email, employmentType);

    // Leite den Benutzer zur entsprechenden Seite weiter
    Widget nextPage;
    switch (employmentType) {
      case 'sitting':
        nextPage = const SittingPage();
        break;
      case 'standing':
        nextPage = const StandingPage();
        break;
      case 'mixed':
        nextPage = const MixedPage();
        break;
      default:
        nextPage = const Scaffold(
          body: Center(child: Text('Unexpected state')),
        );
        break;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('What kind of work environment do you have?'),
            RadioListTile<String>(
              title: const Text('Sitting'),
              value: 'sitting',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value ?? 'sitting';
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Standing'),
              value: 'standing',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value ?? 'standing';
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Mixed'),
              value: 'mixed',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value ?? 'mixed';
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSelection,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
