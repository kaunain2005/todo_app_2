import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../core/theme_provider.dart';
import '../../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _fs = FirestoreService();
  bool _editing = false;
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _loading = true;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    if (user == null) return;
    final up = await _fs.getProfile(user.uid);
    setState(() {
      _profile = up;
      _nameCtrl.text = up?.displayName ?? user.displayName ?? '';
      _bioCtrl.text = up?.bio ?? '';
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser!;
    await _fs.updateProfile(user.uid, {
      'displayName': _nameCtrl.text.trim(),
      'bio': _bioCtrl.text.trim(),
    });
    setState(() => _editing = false);
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = auth.currentUser;

    if (user == null) return const Scaffold(body: Center(child: Text('No user logged in')));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                CircleAvatar(radius: 36, child: Text((_profile?.displayName.isNotEmpty ?? false) ? _profile!.displayName[0] : 'U')),
                const SizedBox(height: 12),
                if (!_editing)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_profile?.displayName ?? user.displayName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(user.email ?? ''),
                      const SizedBox(height: 8),
                      Text(_profile?.bio ?? ''),
                    ],
                  )
                else
                  Column(
                    children: [
                      TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                      const SizedBox(height: 8),
                      TextField(controller: _bioCtrl, decoration: const InputDecoration(labelText: 'Bio')),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_editing) _saveProfile();
                        setState(() => _editing = !_editing);
                      },
                      child: Text(_editing ? 'Save' : 'Edit'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => auth.signOut(),
                      child: const Text('Sign out'),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Text('Dark Mode'),
                        Switch(
                          value: themeProvider.mode == ThemeMode.dark,
                          onChanged: (v) {
                            themeProvider.toggle();
                            // Optionally persist theme to Firestore
                            _fs.createOrUpdateProfile(user.uid, {'theme': themeProvider.mode == ThemeMode.dark ? 'dark' : 'light'});
                          },
                        ),
                      ],
                    )
                  ],
                )
              ]),
            ),
    );
  }
}
