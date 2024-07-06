import 'dart:io';
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final dynamic results;
  final dynamic gradcamImage;

  const ResultsPage(
      {super.key, required this.results, required this.gradcamImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Results: $results'),
            const SizedBox(height: 20),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (gradcamImage is File) {
      // If gradcamImage is of type File
      return Image.file(gradcamImage);
    } else if (gradcamImage is Image) {
      // If gradcamImage is of type Image widget
      return gradcamImage;
    } else {
      // Handle other cases or return a placeholder if needed
      return const Text('No image available');
    }
  }
}
