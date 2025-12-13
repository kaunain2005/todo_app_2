import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../core/constants.dart';
import '../../routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Widget _buildImage(IconData icon, double size) => Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.violet, AppColors.indigo]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: size, color: Colors.white),
      );

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Organize beautifully",
          body: "Create tasks, set priorities, and stay focused.",
          image: _buildImage(Icons.check_circle_outline, 72),
        ),
        PageViewModel(
          title: "Sync to cloud",
          body: "All your tasks are safely stored in Firebase Firestore.",
          image: _buildImage(Icons.cloud_sync_outlined, 72),
        ),
        PageViewModel(
          title: "Personalize",
          body: "Toggle dark mode and manage your profile.",
          image: _buildImage(Icons.person, 72),
        ),
      ],
      onDone: () {
        Navigator.pushReplacementNamed(context, Routes.auth);
      },
      showBackButton: true,
      showNextButton: true,
      next: const Text('Next'),
      back: const Text('Prev'),
      done: const Text('Get started', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        activeColor: AppColors.violet,
      ),
    );
  }
}
