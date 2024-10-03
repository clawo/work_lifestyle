import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_lifestyle/assessment_page.dart';

class ActivityPage extends StatefulWidget {
  final String email; // E-Mail-Parameter hinzufügen

  const ActivityPage({super.key, required this.email}); // E-Mail als Pflichtparameter

  @override
  ActivityPageState createState() => ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  double _activityLevel = 1;

  Future<void> _next() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('activityLevel', _activityLevel);

    // Verwende den BuildContext nur, wenn das Widget noch im Baum ist
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AssessmentPage(email: widget.email), // E-Mail weitergeben
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Level')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('How many times a week are you active?'),
            Slider(
              value: _activityLevel,
              min: 1,
              max: 7,
              divisions: 6,
              label: _activityLevel.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _activityLevel = value;
                });
              },
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
}
