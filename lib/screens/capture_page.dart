import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:amd_app/predictor.dart';
import 'results_page.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  CapturePageState createState() => CapturePageState();
}

class CapturePageState extends State<CapturePage> {
  File? _image;
  List? _results;
  File? _gradcamImage;
  final picker = ImagePicker();

  void _showSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _processImage(_image!);
    }
  }

  Future<void> _processImage(File image) async {
    if (!mounted) return;
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

      final directory = await getApplicationDocumentsDirectory();
      final gradcamFile = File('${directory.path}/gradcam.png');
      gradcamFile.writeAsBytesSync(img.encodePng(gradcamImage));

      if (!mounted) return;
      setState(() {
        _results = results;
        _gradcamImage = gradcamFile;
      });

      Navigator.pop(context);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultsPage(results: _results, gradcamImage: _gradcamImage!),
        ),
      );
    } catch (e) {
      if (!mounted) return;
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
        title: const Text('Capture Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showSourceBottomSheet(context),
              child: const Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}
