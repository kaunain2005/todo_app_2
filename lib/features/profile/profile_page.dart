// lib/features/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/profile_service.dart';
import '../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileService = ProfileService();
  final _authService = AuthService();

  final _nameController = TextEditingController();

  bool _isEditing = false;

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current password',
                ),
              ),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

                try {
                  await _authService.updatePassword(
                    currentPassword: currentCtrl.text,
                    newPassword: newCtrl.text,
                  );

                  if (!mounted) return;

                  navigator.pop();

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? 'Authentication error'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                await _profileService.updateName(_nameController.text.trim());
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _profileService.profileStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text('Profile not found'));
          }

          _nameController.text = data['name'] ?? '';
          final isDark = data['theme'] == 'dark';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Text('Email: ${data['email']}'),

                const SizedBox(height: 16),

                TextField(
                  controller: _nameController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 24),

                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: isDark,
                  onChanged: (value) async {
                    final mode = value ? ThemeMode.dark : ThemeMode.light;

                    await themeController.setTheme(mode);
                    await _profileService.updateTheme(value ? 'dark' : 'light');
                  },
                ),

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change password'),
                  onTap: _showChangePasswordDialog,
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: _authService.logout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
