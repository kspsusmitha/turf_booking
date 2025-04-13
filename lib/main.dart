import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitch_planner/firebase_options.dart';
import 'package:pitch_planner/screens/splash_screen.dart';
import 'package:pitch_planner/theme/app_theme.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PitchPlannerApp());
}

class PitchPlannerApp extends StatelessWidget {
  const PitchPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch Planner',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
