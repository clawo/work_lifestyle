import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'education_page.dart';
import 'welcome_page.dart';
import 'theme.dart'; // Das Theme-File importieren
import 'package:work_lifestyle/Database/user_database.dart'; // Die Datenbank importieren

class StandingPage extends StatefulWidget {
  const StandingPage({super.key});

  @override
  StandingPageState createState() => StandingPageState();
}

class StandingPageState extends State<StandingPage> {
  int _selectedIndex = 0;
  final UserDatabase _database = UserDatabase.instance; // Instanziiere die Datenbank

  // Verwendet den Textstil aus dem App-Theme
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
    // Lade den Benutzernamen (given_name) aus der Datenbank
    final userDetails = await _database.getUserDetails('username@example.com'); // Ersetze mit tatsächlichem Username/Email-Parameter
    return userDetails?['given_name'] ?? 'User'; // Fallback auf 'User', wenn kein Name gefunden wird
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standing Page'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Nutzt die Farbe aus dem Theme
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
        color: AppColors.primaryColor, // Nutzt die Primärfarbe aus dem Theme
        child: Center(
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      drawer: FutureBuilder<String>(
        future: _getUserName(),
        builder: (context, snapshot) {
          String userName = 'User';
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            userName = snapshot.data!;
          }

          return Drawer(
            child: Container(
              color: AppColors.primaryColor, // Nutzt die Primärfarbe für den Drawer-Hintergrund
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppColors.buttonColor, // Nutzt die Akzentfarbe für den DrawerHeader
                    ),
                    child: Text(
                      'Hello, $userName',
                      style: AppTextStyles.heading, // Nutzt den Button-Stil für den Text
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
                    onTap: () {
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
