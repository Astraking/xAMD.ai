import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to use the AMD Screening App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Capture or select a retinal image using the Capture button.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                '2. The app will process the image and provide a prediction.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                '3. Check the Info page for more information about AMD.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                '4. Use the History page to view previously uploaded images.',
                style: TextStyle(fontSize: 16),
              ),
              // Add more instructions as needed
            ],
          ),
        ),
      ),
    );
  }
}
