import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'education_page.dart';
import 'welcome_page.dart';
import 'theme.dart'; // Importiert die theme.dart Datei
import 'package:work_lifestyle/Database/user_database.dart'; // Importiert die Datenbankklasse

class MixedPage extends StatefulWidget {
  const MixedPage({super.key});

  @override
  MixedPageState createState() => MixedPageState();
}

class MixedPageState extends State<MixedPage> {
  int _selectedIndex = 0;
  final UserDatabase _database = UserDatabase.instance; // Instanziiere die Datenbank

  // Verwendet den Textstil aus AppTextStyles anstelle eines hartcodierten Stils
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: AppTextStyles.heading),
    Text('Index 1: Business', style: AppTextStyles.heading),
    Text('Index 2: School', style: AppTextStyles.heading),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getUserName() async {
    try {
      // Lade den Benutzernamen (given_name) aus der Datenbank
      final userDetails = await _database.getUserDetails('username@example.com'); // Ersetze mit dem tatsächlichen Username/Email-Parameter

      // Debugging: Überprüfe, ob userDetails null ist oder nicht
      if (userDetails == null) {
        return 'User';
      }

      // Debugging: Überprüfe den Inhalt von userDetails

      return userDetails['given_name'] ?? 'User'; // Fallback zu 'User', wenn kein Name gefunden wird
    } catch (e) {
      return 'User'; // Fallback bei Fehler
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mixed Page'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Verwendet die AppBar-Farbe aus dem Theme
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Container(
        color: AppColors.primaryColor, // Verwendet die Primärfarbe aus dem Theme
        child: Center(
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      drawer: FutureBuilder<String>(
        future: _getUserName(),
        builder: (context, snapshot) {
          String userName = 'User'; // Standardwert
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            userName = snapshot.data!;
          }

          return Drawer(
            child: Container(
              color: AppColors.primaryColor, // Verwendet die Primärfarbe für den Drawer-Hintergrund
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppColors.buttonColor, // Verwendet die Akzentfarbe für den DrawerHeader
                    ),
                    child: Text(
                      'Hello, $userName',
                      style: AppTextStyles.heading, // Verwendet den Button-Stil für den Text
                    ),
                  ),
                  ListTile(
                    title: const Text('Education'),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EducationPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Assessments'),
                    selected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Workouts'),
                    selected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('My Profile'),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      // Hier kannst du eine benutzerdefinierte Logout-Logik hinzufügen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
