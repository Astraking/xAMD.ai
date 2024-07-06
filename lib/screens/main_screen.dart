import 'package:flutter/material.dart';
import 'capture_page.dart';
import 'info_page.dart';
import 'help_page.dart';
import 'history_page.dart';
import '../widgets/custom_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late ThemeData _currentTheme;
  late ThemeMode _currentThemeMode;

  @override
  void initState() {
    super.initState();
    _currentTheme = ThemeManager.instanceOf(context).lightTheme;
    _currentThemeMode = ThemeManager.instanceOf(context).themeMode;
  }

  void updateTheme() {
    setState(() {
      _currentTheme =
          ThemeManager.instanceOf(context).themeMode == ThemeMode.light
              ? ThemeManager.instanceOf(context).lightTheme
              : ThemeManager.instanceOf(context).darkTheme;
      _currentThemeMode = ThemeManager.instanceOf(context).themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AMD Screening'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              final Brightness currentBrightness =
                  MediaQuery.of(context).platformBrightness;
              const ThemeMode nextMode = ThemeMode.system;

              // Toggle between light and dark mode
              if (currentBrightness == Brightness.light) {
                // Switch to dark mode
                ThemeManager.instanceOf(context).changeTheme(
                  ThemeManager.instanceOf(context).darkTheme,
                  nextMode,
                );
              } else {
                // Switch to light mode
                ThemeManager.instanceOf(context).changeTheme(
                  ThemeManager.instanceOf(context).lightTheme,
                  nextMode,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the next generation of AMD care!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'Readex Pro'),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/pic1.jpg', // Make sure to add this image to your assets
                width: 400,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Capture',
              icon: Icons.camera_alt,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CapturePage()),
                );
              },
            ),
            CustomButton(
              text: 'Info',
              icon: Icons.info,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
            ),
            CustomButton(
              text: 'Help',
              icon: Icons.help,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            CustomButton(
              text: 'History',
              icon: Icons.history,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeManager {
  static ThemeManager? _instance;
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _themeMode;
  late BuildContext _context;

  ThemeManager._();

  factory ThemeManager.instanceOf(BuildContext context) {
    if (_instance == null) {
      _instance = ThemeManager._();
      _instance!._context = context;
      _instance!._lightTheme = ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.orange,
        ),
      );
      _instance!._darkTheme = ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.orange,
        ),
      );
      _instance!._themeMode = ThemeMode.system;
    }
    return _instance!;
  }

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeData theme, ThemeMode mode) {
    _lightTheme = theme.copyWith();
    _darkTheme = theme.copyWith();
    _themeMode = mode;
    _updateTheme();
  }

  void _updateTheme() {
    final state = _context.findRootAncestorStateOfType<MainScreenState>();
    if (state != null) {
      state.updateTheme();
    }
  }
}
