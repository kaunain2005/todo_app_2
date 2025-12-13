import 'package:flutter/widgets.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/main_bottom_nav.dart';

// Import the AuthGate we just added
import 'screens/auth/auth_gate.dart';

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      onboarding: (_) => const OnboardingPage(),
      auth: (_) => const AuthGate(),          // now defined and imported
      login: (_) => const LoginPage(),
      register: (_) => const RegisterPage(),
      main: (_) => const MainBottomNav(),
    };
  }
}
