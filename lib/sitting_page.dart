import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'education_page.dart';
import 'welcome_page.dart';
import 'theme.dart'; // Import the theme file
import 'package:work_lifestyle/Database/user_database.dart'; // Importiere die Datenbankklasse

class SittingPage extends StatefulWidget {
  const SittingPage({super.key});

  @override
  SittingPageState createState() => SittingPageState();
}

class SittingPageState extends State<SittingPage> {
  int _selectedIndex = 0;
  final UserDatabase _database = UserDatabase.instance; // Instanziiere die Datenbank

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: AppTextStyles.body),
    Text('Index 1: Business', style: AppTextStyles.body),
    Text('Index 2: School', style: AppTextStyles.body),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getUserName() async {
    // Lade den Benutzernamen (given_name) aus der Datenbank
    final userDetails = await _database.getUserDetails('username@example.com'); // Ersetze mit dem tatsächlichen Username/Email-Parameter
    return userDetails?['given_name'] ?? 'User'; // Fallback auf 'User', wenn kein Name gefunden wird
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sitting Page', style: AppTextStyles.heading),
        backgroundColor: AppColors.appBarColor,
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
      body: Center(
        child: _widgetOptions[_selectedIndex],
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
              color: AppColors.primaryColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppColors.buttonColor,
                    ),
                    child: Text(
                      'Hello, $userName',
                      style: AppTextStyles.heading.copyWith(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: const Text('Education', style: AppTextStyles.body),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EducationPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Assessments', style: AppTextStyles.body),
                    selected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Workouts', style: AppTextStyles.body),
                    selected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('My Profile', style: AppTextStyles.body),
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
                    title: const Text('Settings', style: AppTextStyles.body),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Logout', style: AppTextStyles.body),
                    onTap: () {
                      // Hier kannst du eine benutzerdefinierte Logout-Logik hinzufügen
                      // z.B. das Löschen von Sitzungstokens oder den Benutzer zur WelcomePage leiten
                      Navigator.of(context).pushReplacement(
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
