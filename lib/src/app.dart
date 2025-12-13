import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme_provider.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Violet ToDo',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.mode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.offWhite,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.violet),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.indigo, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      initialRoute: Routes.splash,
      routes: Routes.getRoutes(),
      // Fallback on unknown route
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }
}
