import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: auth.logout,
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
