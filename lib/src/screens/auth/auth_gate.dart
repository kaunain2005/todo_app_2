import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../routes.dart';

/// AuthGate: simple widget that decides whether to show the main app or the auth flow.
/// It listens to AuthService.authStateChanges and performs navigation accordingly.
class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    // Listen to auth state changes and navigate appropriately
    _sub = auth.authStateChanges.listen((user) {
      if (user == null) {
        // Not signed in -> go to login
        if (mounted) Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        // Signed in -> go to main
        if (mounted) Navigator.pushReplacementNamed(context, Routes.main);
      }
    });
    // In case the stream doesn't immediately emit, check currentUser and navigate after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = Provider.of<AuthService>(context, listen: false).currentUser;
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        Navigator.pushReplacementNamed(context, Routes.main);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple splash-like placeholder while we decide:
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
