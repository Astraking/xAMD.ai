import 'package:flutter/material.dart';
import 'main_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      _buildPage(
        imagePath: 'assets/images/pic2.jpg',
        title: 'UNDERSTAND AMD',
        description:
            'Learn about Age-related Macular Degeneration, its causes, symptoms, and risk factors.',
      ),
      _buildPage(
        imagePath: 'assets/images/pic3.jpg',
        title: 'IMPORTANCE OF EARLY DETECTION',
        description:
            'Early detection of AMD is crucial to prevent severe vision loss. Regular screening can help.',
      ),
      _buildPage(
        imagePath: 'assets/images/pic4.jpg',
        title: 'START SCREENING NOW',
        description:
            'Use this app to screen for AMD by uploading retinal images. Get started to protect your vision.',
        showButton: true,
        onButtonPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        },
      ),
    ];
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String description,
    bool showButton = false,
    VoidCallback? onButtonPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (showButton)
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Example primary color
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('GET STARTED'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: _buildPages(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.red // Example primary color
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
