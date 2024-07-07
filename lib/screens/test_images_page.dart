import 'package:flutter/material.dart';
import 'dart:io';
import 'package:amd_app/predictor.dart';
import 'results_page.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TestImagesPage extends StatefulWidget {
  const TestImagesPage({super.key});

  @override
  TestImagesPageState createState() => TestImagesPageState();
}

class TestImagesPageState extends State<TestImagesPage> {
  final List<String> _imagePaths = [
    'assets/images/normal.jpg',
    'assets/images/amd.jpg',
    // Add more image paths as needed
  ];

  Future<void> _processImage(String imagePath) async {
    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List bytes = byteData.buffer.asUint8List();
    File image = File('${(await getTemporaryDirectory()).path}/temp.jpg');
    await image.writeAsBytes(bytes);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await Predictor.loadModel();
      var results = await Predictor.runModelOnImage(image);
      var gradcamImage = await Predictor.generateGradCAM(image);

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultsPage(results: results, gradcamImage: gradcamImage),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('An error occurred while processing the image.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Images'),
      ),
      body: ListView.builder(
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(_imagePaths[index],
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text('Test Image ${index + 1}'),
            onTap: () => _processImage(_imagePaths[index]),
          );
        },
      ),
    );
  }
}
