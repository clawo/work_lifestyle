import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Profil'),
        //backgroundColor: const Color(0xFFFCEDE9), // Richtige Verwendung von Color
      ),
      body: const Center(
        child: Text('This is the Profile page.'),
      ),
    );
  }
}
