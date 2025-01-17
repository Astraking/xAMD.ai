import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'screens/onboarding_page.dart';

void main() {
  _setupLogging();
  runApp(const AMDScreeningApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Set the root logger level to ALL
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class AMDScreeningApp extends StatelessWidget {
  const AMDScreeningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMD Screening App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.orange,
        ),
      ),
      home: const OnboardingPage(),
    );
  }
}
