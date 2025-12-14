import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/profile_service.dart';
import '../../main.dart';
import '../onboarding/onboarding_page.dart';
import '../auth/auth_gate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    /// 1️⃣ Load cached theme instantly
    await themeController.loadFromCache();

    /// 2️⃣ Sync with Firebase if logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profileService = ProfileService();
      final remoteTheme = await profileService.getThemeOnce();

      if (remoteTheme != null) {
        await themeController.setTheme(
          remoteTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
        );
      }
    }

    /// 3️⃣ Onboarding logic (unchanged)
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_done') ?? false;

    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => seen ? AuthGate() : const OnboardingPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBorder,
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_outline, size: 96, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Todo App 2.0',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
